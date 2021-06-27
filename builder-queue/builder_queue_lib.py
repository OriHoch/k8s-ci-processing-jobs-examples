import subprocess


def build(arch, github_user, tag_name):
    subprocess.check_call(['./entrypoint.sh', arch, github_user, tag_name])
