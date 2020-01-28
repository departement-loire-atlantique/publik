#!/usr/bin/env python

import os
import re
import shutil
import glob
import subprocess

# This script converts from the docker version to a shell install version
# Useful for installation without docker


# Manual installation
# - Init a database using ../postgresql/docker-entrypoint-initdb.d/init-database.sh
# - Add db, smtp and rabbitmq to /etc/hosts
# - Excute ./docker2shell.py
# - Open schellinstall folder
#   - Update database connexion in config files (*.py)
#   - Create env file and load data in bash session for envsub
#   - Update NGINX ports in *.template
#   - Update SMTP config (config.py and wcs.settings.py)
#   - Turn debug off if needed in config files (*.py)
#   - Execute install.sh
#   - Start app with start-xxx.sh

def file_replace(replace_dict, source, dest=None, title=None):
    fin = open(source, 'r')
    if dest:
        fout = open(dest, 'a')
    else:
        fd, name = mkstemp()
        fout = open(name, 'w')

    if title:
        fout.write("\n\n################\n")
        fout.write("# " + title + "\n")
        fout.write("################\n\n")

    for line in fin:
        out = line
        for pattern,replace in replace_dict.iteritems():
            out = re.sub(pattern, replace, out)
        fout.write(out)
    try:
        fout.writelines(fin.readlines())
    except Exception as E:
        raise E

    fin.close()
    fout.close()

    if not dest:
        shutil.move(name, source) 
    
apps = ["base", "hobo", "authentic", "combo", "fargo", "passerelle", "wcs"]

project_path = os.getcwd()
bare_path = os.path.join(project_path, "shellinstall")
if not os.path.exists(bare_path):
    os.makedirs(bare_path)
else:
    [os.remove(f) for f in glob.glob(bare_path+"/*")]

replace_dict = {
    "^FROM.*" : "set -eu",
    "^MAINTAINER" : "# MAINTAINER",
    "^VOLUME" : "# VOLUME",
    "^EXPOSE" : "# EXPOSE",
    "^ENTRYPOINT" : "# ENTRYPOINT",
    "^CMD" : "# CMD",
    "^RUN (?P<cmd>.*)" : "echo '\g<cmd>'\n\g<cmd>",
    "^COPY (?P<files>.*)" : "echo 'cp \g<files>'\ncp \g<files>",
    "^ENV\s(?P<name>[A-Z_]*)\s*(?P<value>[a-z]*)" : "export \g<name>=\g<value>",
    "/root" : "/usr/local/bin",
    "rm \-rf /var/lib/apt/lists/\*" : "echo 'dependencies downloaded'"
    }

do_not_copy = ["Dockerfile", "LICENSE", "README.md", \
    ".git", "nginx.template", "start.sh", "stop.sh"]

installgru = "set -eu\n"
startgru = ""
stopgru = ""
configuregru = ""
envextractor = re.compile("(envsubst.*)")

for app in apps:
    app_path = os.path.join(project_path, app)
    
    if "Dockerfile" in os.listdir(app) :
        print("Converting {} docker image...".format(app))

        # Rename nginx template using app name
        nginx_path = os.path.join(app_path, "nginx.template")
        if os.path.isfile(nginx_path):
            nginx_new_name = "nginx-"+app+".template"
            replace_dict.update({"nginx.template" : nginx_new_name})
            shutil.copyfile(nginx_path, os.path.join(bare_path, nginx_new_name))
        
        # Convert docker entrypoint into startup script
        entrypoint_path = os.path.join(app_path, "start.sh")
        if os.path.isfile(entrypoint_path):
            startappscript = "start-"+app+".sh"
            replace_dict.update({"start.sh" : startappscript})
            # delete the 'exec' command in the script
            with open(entrypoint_path) as f:
                newContent = f.read().replace('exec "$@"', '')
                newContent = envextractor.sub('# moved to configure.sh \\1', newContent)
                configuregru += "\n".join([ a + "\n" for a in envextractor.findall(newContent)])
            with open(os.path.join(bare_path, startappscript), "w+") as f:
                f.write(newContent)
            startgru += "echo " + startappscript + " running ... \n"
            startgru += "./" + startappscript + "\n"
        
        # Convert docker stop script
        entrypoint_path = os.path.join(app_path, "stop.sh")
        if os.path.isfile(entrypoint_path):
            stopappscript = "stop-"+app+".sh"
            replace_dict.update({"stop.sh" : stopappscript})
            shutil.copyfile(entrypoint_path, os.path.join(bare_path, stopappscript))
            stopgru += "echo " + stopappscript + " running ... \n"
            stopgru += "./" + stopappscript + "\n" 

        # Convert dockerfile
        installappscript = "install-"+app+".sh"
        file_replace(replace_dict, \
            os.path.join(app_path, "Dockerfile"), \
            os.path.join(bare_path, installappscript), app)
        installgru += "./" + installappscript + "\n"
        
        # Copy other files
        files = [f for f in os.listdir(app) if f not in do_not_copy]
        for file in files:
            file_path = os.path.join(app_path, file)
            if os.path.isfile(os.path.join(bare_path, file)):
                print("Error, file %s already exists", file)
            shutil.copy(file_path, bare_path)
        print("{} docker image converted".format(app))

# Copy start-all and stop-all in /usr/local/bin
installgru += "\ncp start-all.sh stop-all.sh /usr/local/bin/"
installgru += "\nchmod +x /usr/local/bin/start-all.sh /usr/local/bin/stop-all.sh\n"
installgru += "\necho 'Installation completed'"

with open(os.path.join(bare_path, "install.sh"), "w") as f:
    f.write(installgru)

with open(os.path.join(bare_path, "start-all.sh"), "w") as f:
    f.write(startgru)

with open(os.path.join(bare_path, "stop-all.sh"), "w") as f:
    f.write(stopgru)

configuregru += "\necho config ... done"

with open(os.path.join(bare_path, "configure.sh"), "w") as f:
    f.write(configuregru)

subprocess.call("chmod +x " + os.path.join(bare_path, "*.sh"), shell=True)