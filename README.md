[![Build Status](https://secure.travis-ci.org/davidski/chef-vulnpryer.png)](http://travis-ci.org/davidski/chef-vulnpryer)

# vulnpryer-cookbook

Deploys the VulnPryer suite.

## Supported Platforms

- Ubuntu-12
- Ubuntu-14
- CentOS
- Amazon Linux

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['vulnpryer']['config']['s3']['aws_access_key_id']</tt></td>
    <td>String</td>
    <td>AWS Access Key to Post to S3 (will use IAM role creds if nil)</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['vulnpryer']['config']['s3']['aws_secret_access_key_id']</tt></td>
    <td>String</td>
    <td>AWS Secret Key to Post to S3 (will use IAM role creds if nil)</td>
    <td><tt>nil</tt></td>
  </tr>
</table>

## Usage

### vulnpryer::datadrive

Include `vulnpryer` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[vulnpryer::datadrive]"
  ]
}
```
- Creates data path for Mongo instance
- Mounts EBS volume to data location


### vulnpryer::default

Include `vulnpryer` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[vulnpryer::default]"
  ]
}
```

- Creates VulnDB user and group
- Creates AWS credential file if specified (defaults to IAM role if nil)
- Installs python dependencies
- Installs vulnpryer tool chain
- Configures vulnpryer configuration file

### vulnpryer::run_immediate

Immediately run the vulnpryer.py wrapper script.

```json
{
  "run_list": [
    "recipe[vulnpryer::default]"
  ]
}

### vulnpryer::schedule

Include `vulnpryer` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[vulnpryer::schedule]"
  ]
}
```
- Schedules daily updates from VulnDB
- Schedules weekly TRL updates


## License and Authors

Author:: David F. Severski (<davidski@deadheaven.com>)
