<div align="center">
	<p><img src="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/160/apple/325/fire_1f525.png" width="100px"></p>
	<h1>statsd_exporter</h1>
	<p>Built-from-source container image of <a href="https://github.com/prometheus/statsd_exporter">statsd_exporter</a></p>
	<code>docker pull quay.io/ricardbejarano/statsd_exporter</code>
</div>


## Features

* Compiled from source during build time
* Built `FROM scratch`, with zero bloat
* Reduced attack surface (no shell, no UNIX tools, no package manager...)
* Runs as unprivileged (non-`root`) user


## Tags

### Docker Hub

Available on Docker Hub as [`docker.io/ricardbejarano/statsd_exporter`](https://hub.docker.com/r/ricardbejarano/statsd_exporter):

- [`0.22.8`, `latest` *(Dockerfile)*](Dockerfile)

### RedHat Quay

Available on RedHat Quay as [`quay.io/ricardbejarano/statsd_exporter`](https://quay.io/repository/ricardbejarano/statsd_exporter):

- [`0.22.8`, `latest` *(Dockerfile)*](Dockerfile)
