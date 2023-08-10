# from diagrams import Cluster, Diagram
# from diagrams.aws.database import RDS
# from diagrams.aws.compute import EC2

# with Diagram("2-tier architecture", show=False, outformat="png"):
#     with Cluster("VPC"):
#         with Cluster("Public Subnet"):
#             with Cluster("App Security Group"):
#                 App = EC2("App")
#         with Cluster("Private Subnet"):
#             with Cluster("Database Security Group"):
#                 DB = RDS("Database")

#     App >> DB