import os
import sys
import subprocess

from rq import Queue
from redis import Redis

from builder_queue_lib import build


RQ_REDIS_HOST = os.environ.get('RQ_REDIS_HOST') or 'localhost'
RQ_REDIS_PORT = int(os.environ.get('RQ_REDIS_PORT') or '6379')
RQ_REDIS_DB = int(os.environ.get('RQ_REDIS_DB') or '5')
RQ_JOB_TIMEOUT_SECONDS = int(os.environ.get('RQ_JOB_TIMEOUT') or '240')


def main(arch, github_user, tag_name):
    r = Redis(RQ_REDIS_HOST, RQ_REDIS_PORT, db=RQ_REDIS_DB)
    q = Queue(connection=r)
    try:
        if arch == 'all':
            print("Queueing all supported OS architectures")
            out = subprocess.check_output(['./entrypoint.sh', '--list'])
            for arch in (line.strip().decode() for line in out.splitlines() if line.strip()):
                main(arch, github_user, tag_name)
        else:
            print("Queueing OS architecture (arch={} github_user={} tag_name={})".format(arch, github_user, tag_name))
            q.enqueue(build, arch, github_user, tag_name, job_timeout=RQ_JOB_TIMEOUT_SECONDS)
    finally:
        r.close()



if __name__ == "__main__":
    main(*sys.argv[1:])
