ARG TERRAFORM_PROVIDER=hashicorp
ARG TERRAFORM_VERSION=1.10.2
ARG TERRAGRUNT_VERSION=v0.71.1
ARG OPENTOFU_VERSION=1.8.0
ARG BINARY_ARCH=arm64
ARG WORKSPACE_MODE=mount

# Multi-stage build to support different providers
FROM ${TERRAFORM_PROVIDER}/terraform:${TERRAFORM_VERSION} AS base

# Install minimal dependencies
RUN apk add --no-cache \
    bash \
    curl \
    git \
    jq \
    wget

# Create a directory for binaries
RUN mkdir -p /usr/local/bin && chmod 755 /usr/local/bin

# Download and install Terragrunt with explicit permissions
ARG TERRAGRUNT_VERSION
ARG BINARY_ARCH
RUN TERRAGRUNT_BINARY="terragrunt_linux_${BINARY_ARCH}" \
    && wget "https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/${TERRAGRUNT_BINARY}" -O /usr/local/bin/terragrunt \
    && chmod 755 /usr/local/bin/terragrunt

# Download and install OpenTofu using official installer
RUN curl -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh \
    && chmod +x install-opentofu.sh \
    && ./install-opentofu.sh --install-method standalone --skip-verify \
    && rm -f install-opentofu.sh \
    && chmod 755 /usr/local/bin/tofu

# Final stage
FROM base

# Set working directory
WORKDIR /workspace

# Copy only necessary binaries
COPY --from=base --chmod=755 /usr/local/bin/terragrunt /usr/local/bin/terragrunt
COPY --from=base --chmod=755 /usr/local/bin/tofu /usr/local/bin/tofu

# Create entrypoint script with workspace mode handling
RUN echo '#!/bin/bash' > /entrypoint.sh \
    && echo 'if [ "$WORKSPACE_MODE" = "copy" ]; then' >> /entrypoint.sh \
    && echo '  cp -R /host/* /workspace/' >> /entrypoint.sh \
    && echo 'fi' >> /entrypoint.sh \
    && echo 'exec "$@"' >> /entrypoint.sh \
    && chmod +x /entrypoint.sh

# Default command
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
