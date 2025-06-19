# Mabin Accolite - Apache Flink Deployment

A containerized Apache Flink application with Kubernetes deployment configurations for stream processing workloads.

## Overview

This project provides a Docker-based Apache Flink deployment with comprehensive Kubernetes manifests for production environments. It includes configurations for Flink job managers, task managers, and supporting infrastructure components like Couchbase.

## Project Structure

```
├── dockerfile                    # Main Docker image configuration
├── docker-entrypoint.sh         # Container entry point script
├── deploy/                       # Kubernetes deployment manifests
│   └── manifest-yaml/
│       ├── ConfigMaps/          # Flink configuration files
│       ├── Couchbase/           # Couchbase deployment configs
│       ├── Custom/              # Custom deployment resources
│       └── Services/            # Kubernetes service definitions
├── deploy.zip                   # Compressed deployment artifacts
├── monitoring.zip               # Monitoring and observability configs
└── MONITORING-DONOTTOUCH.zip    # Protected monitoring resources
```

## Prerequisites

- Docker Engine 19.03+
- Kubernetes cluster 1.16+
- kubectl configured for your cluster
- Access to the internal Docker registry: `docker-rt-interconnect.pruregistry.intranet.asia:8443`

## Quick Start

### Building the Docker Image

```bash
docker build -t your-registry/flink-app:latest .
```

### Deploying to Kubernetes

1. Extract the deployment manifests:
   ```bash
   unzip deploy.zip
   ```

2. Update the image references in the deployment files:
   ```bash
   # Replace ##IMAGE## placeholders with your actual image
   find deploy/manifest-yaml -name "*.yml" -o -name "*.yaml" | \
     xargs sed -i 's/##IMAGE##/your-registry\/flink-app:latest/g'
   ```

3. Deploy the Flink cluster:
   ```bash
   kubectl apply -f deploy/manifest-yaml/
   ```

## Configuration

### Flink Configuration

The Flink configuration is managed through Kubernetes ConfigMaps located in [`deploy/manifest-yaml/ConfigMaps/`](deploy/manifest-yaml/ConfigMaps/):

- [`flink-conf-configmap.yaml`](deploy/manifest-yaml/ConfigMaps/flink-conf-configmap.yaml) - Main Flink configuration
- [`log4jprops-configmap.yaml`](deploy/manifest-yaml/ConfigMaps/log4jprops-configmap.yaml) - Logging configuration
- [`taskmgr-configmap.yaml`](deploy/manifest-yaml/ConfigMaps/taskmgr-configmap.yaml) - Task manager settings

### Environment Variables

Key environment variables for the container:

- `JOB_MANAGER_RPC_ADDRESS` - JobManager RPC address (defaults to container hostname)
- `FLINK_HOME` - Flink installation directory (default: `/opt/flink`)

## Components

### Job Manager

The Job Manager coordinates the Flink cluster and manages job execution. Configuration is handled through the [`docker-entrypoint.sh`](docker-entrypoint.sh) script.

### Task Manager

Task Managers execute the actual stream processing tasks. They connect to the Job Manager and process data streams.

### Couchbase Integration

The project includes Couchbase deployment configurations in [`deploy/manifest-yaml/Couchbase/`](deploy/manifest-yaml/Couchbase/) for data persistence and caching.

## Monitoring

Monitoring configurations are provided in the monitoring archives. Extract and deploy these for comprehensive observability:

```bash
# Note: MONITORING-DONOTTOUCH.zip contains protected resources
unzip monitoring.zip
```

## Development

### Local Development

For local development, you can run the Flink cluster using Docker Compose or directly with Docker:

```bash
# Run as Job Manager
docker run -it --rm your-registry/flink-app:latest jobmanager

# Run as Task Manager
docker run -it --rm your-registry/flink-app:latest taskmanager
```

### Custom Applications

To deploy your own Flink applications:

1. Add your JAR files to the `lib/` directory
2. Update the [`dockerfile`](dockerfile) to copy your application JARs
3. Rebuild the Docker image
4. Update the Kubernetes deployment manifests

## Troubleshooting

### Common Issues

1. **Image Pull Errors**: Ensure you have access to the internal Docker registry
2. **Permission Issues**: Check that the `flink` user has proper permissions in the container
3. **Configuration Errors**: Verify ConfigMap contents match your cluster requirements

### Logs

Access container logs using:

```bash
kubectl logs -f deployment/flink-jobmanager
kubectl logs -f deployment/flink-taskmanager
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly in a development environment
5. Submit a pull request

## License

This project is licensed under the Apache License 2.0. See the license header in [`docker-entrypoint.sh`](docker-entrypoint.sh) for details.

## Support

For support and questions, please contact the development team or create an issue in the repository.