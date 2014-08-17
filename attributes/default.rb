#VulnDB settings
default['vulnpryer']['config']['vulndb']['consumer_key']      = nil
default['vulnpryer']['config']['vulndb']['consumer_secret']   = nil
default['vulnpryer']['config']['vulndb']['request_token_url'] = 'https://vulndb.cyberriskanalytics.com/oauth/request_token'
default['vulnpryer']['config']['vulndb']['page_size']         = 100
default['vulnpryer']['config']['vulndb']['working_dir']       = '/tmp/'
default['vulnpryer']['config']['vulndb']['json_dir']          = '/data/vulndb_json/'

#S3 settings
default['vulnpryer']['config']['s3']['bucket_name']           = nil
default['vulnpryer']['config']['s3']['key']                   = nil
default['vulnpryer']['config']['s3']['region']                = 'us-west-2'

#RedSeal settings
default['vulnpryer']['config']['redseal']['username']           = nil
default['vulnpryer']['config']['redseal']['password']           = nil
default['vulnpryer']['config']['redseal']['trl_url']   = 'https://www.redsealnetworks.com/login/trl/RedSeal_TRL_7-0-latest.gz'

#Mongo settings
default['vulnpryer']['config']['mongo']['hostname']     = 'localhost'

#EC2 EBS only settings
default['vulnpryer']['ebs']['size']                    = 20

default['vulnpryer']['user']                           = "vulndb"

#VulnPryer repo
default['vulnpryer']['repository']                     = 'https://github.com/davidski/vulnpryer.git'
default['vulnpryer']['repository_branch']              = 'master'