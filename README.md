Simple remote-syslog release for BOSH
=====================================

Your BOSH VMs have lots on them and you want to ship them to a syslog endpoint. This BOSH release has a collocated job for you!

Usage
-----

To use this bosh release, first upload it to your bosh:

```
bosh upload release https://bosh.io/d/github.com/cloudfoundry-community/simple-remote-syslog-boshrelease
```

Add the `simple-remote-syslog` release into your manifest:

```yaml
releases:
- name: simple-remote-syslog
  version: latest
```

For each job that you want to ship some logs add the `remote-syslog` job template to the end of the list:

```yaml
jobs:
- name: router
  instances: 1
  templates:
    - {name: router, release: patroni}
    - {name: remote-syslog, release: simple-remote-syslog}
```

Finally, document where your remote syslog endpoint is:

```yaml
properties:
  remote_syslog:
    address: logs.papertrailapp.com
    port: 54321
```

### Options

By default each log line will include the full BOSH DNS hostname (`0.redis_z1.redis1.my-redis.microbosh`). As these can get quiet long when being viewed in simple log viewers there is an option to include a shorter hostname:

```yaml
properties:
  remote_syslog:
    short_hostname: true
```

The `hostname` will now be in the format `0.redis_z1.my-redis`. The network name and `.microbosh` suffix are removed.
