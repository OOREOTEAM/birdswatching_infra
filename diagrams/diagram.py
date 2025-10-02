# before run script in python environment
# pip install diagrams

from diagrams import Diagram, Cluster
from diagrams.aws.compute import EC2
from diagrams.aws.network import ELB
from diagrams.onprem.database import PostgreSQL
from diagrams.onprem.ci import Jenkins
from diagrams.onprem.network import Consul
from diagrams.onprem.vcs import Github
from diagrams.onprem.iac import Ansible

with Diagram(
    "OREO Birdwatching Project",
    direction='LR',
    filename="oreo_arch_clean",
    show=True,
    graph_attr={"labelloc": "t", "fontsize":"20"}  # Top title
):
  
    # VCS
    git1 = Github("GitHub\nrepo: OREO\nbranch: main")

    # OPS
    with Cluster("OPS"):
        jenkins = Jenkins("Jenkins\nCI Server")
        consul = Consul("Consul\nService Discovery")

    # Ansible
    ans1 = Ansible("Ansible\nplaybook")

    # Load Balancer / Db
    load_balancer = ELB("Load Balancer\nDNS: lb.oreo.com")
    database = PostgreSQL("User DB\nPostgreSQL 14\ndb.local")

    # Webserver Cluster
    with Cluster("Webserver Cluster"):
        svc_group = [
            EC2("Nginx/Flask\nweb1.local"),
            EC2("Nginx/Flask\nweb2.local")
        ]

    git1 >> jenkins >> ans1
    ans1 >> load_balancer
    ans1 >> svc_group
    ans1 >> database

    load_balancer >> svc_group
    svc_group >> database
