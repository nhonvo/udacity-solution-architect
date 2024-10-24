import os

def lambda_handler(event, context):
    return "{} nhon dep trai from viet nam!".format(os.environ['greeting'])
