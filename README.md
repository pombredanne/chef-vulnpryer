[![Build Status](https://secure.travis-ci.org/davidski/chef-vulnpryer.png)](http://travis-ci.org/davidski/chef-vulnpryer)

# vulnpryer-cookbook

Deploys the VulnPryer suite.

## Supported Platforms

- Ubuntu-12
- Ubuntu-14
- CentOS

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['vulnpryer']['tofu']</tt></td>
    <td>Boolean</td>
    <td>whether to include tofu</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### vulnpryer::datadir

Include `vulnpryer` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[vulnpryer::datadir]"
  ]
}
```
### vulnpryer::default

Include `vulnpryer` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[vulnpryer::default]"
  ]
}
```

## License and Authors

Author:: David F. Severski (<davidski@deadheaven.com>)
