import os
import subprocess

# list all files that start with key in the dir $HOME/.config/gcloud/
key = "key"  # You can change this to your desired prefix
gcloud_dir = os.path.expanduser("~/.config/gcloud/")
files = [f for f in os.listdir(gcloud_dir) if f.startswith(key)]

# push into fzf
output = "\n".join(files)
fzf = subprocess.run(['fzf'], input=output,
                         stdout=subprocess.PIPE, text=True)
selected_name = fzf.stdout
selected_name = selected_name.strip()

# set env HELLO_WORLD to selected_name
print(f"export GOOGLE_APPLICATION_CREDENTIALS=\"{gcloud_dir+selected_name}\"")
