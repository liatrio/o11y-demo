# o11y-demo

## Pre-requisites

1. Docker images are hosted on ghcr see [here](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-with-a-personal-access-token-classic) for instructions on how to login
2. Collector GitHub Personal Access Token requirements: 
   1. contents read
   2. metadata read

## Getting Started

1. Clone this repo
2. Create a `.env` file in the root of the repo, make a copy of the [example](.env.example)
3. Run `docker compose up`
4. To open grafan navigate to [http://localhost:8080](http://localhost:8080)
5. To view the demo dashboard in Grafana go to dashboards > o11y > demo

| Service | Link |
| --- | --- |
| Grafana | http://localhost:8080 |
| Prometheus | http://localhost:8081 |
| OTLP gRPC Receiver | http://localhost:4317 |
| OTLP HTTP Receiver | http://localhost:4318 |
| Collector Prometheus Metrics | http://localhost:9464/metrics |
| Collector Health Check | http://localhost:8888/metrics |

## TODO

- [x] consider publishing collector image with arch amd64 as latest tag
  - Decision was made to just use amd64 arch in the compose file for now
- [ ] fix panic in collector
- [ ] add organization attribute to metrics
- [ ] debug duplicate metric entires
- [ ] nail down final demo story and flow