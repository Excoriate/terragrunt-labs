# -------------------------------------------
# 1) Declare build args for Terraform, Terragrunt, OpenTofu, etc.
# -------------------------------------------
    ARG TERRAFORM_PROVIDER=hashicorp
    ARG TERRAFORM_VERSION=1.10.2
    ARG TERRAGRUNT_VERSION=v0.71.1
    ARG OPENTOFU_VERSION=1.8.0
    ARG BINARY_ARCH=arm64
    # This will control whether we copy files at build time or mount at runtime.
    ARG WORKSPACE_MODE=mount

    # -------------------------------------------
    # 2) Build base image with all required binaries
    # -------------------------------------------
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

    # Download and install Terragrunt
    ARG TERRAGRUNT_VERSION
    ARG BINARY_ARCH
    RUN TERRAGRUNT_BINARY="terragrunt_linux_${BINARY_ARCH}" \
        && wget "https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/${TERRAGRUNT_BINARY}" \
             -O /usr/local/bin/terragrunt \
        && chmod 755 /usr/local/bin/terragrunt

    # Download and install OpenTofu using official installer
    RUN curl -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh \
        && chmod +x install-opentofu.sh \
        && ./install-opentofu.sh --install-method standalone --skip-verify \
        && rm -f install-opentofu.sh \
        && chmod 755 /usr/local/bin/tofu


    # -------------------------------------------
    # 3) Stage named "mount" (default if WORKSPACE_MODE=mount).
    #    Does not copy local files. We rely on runtime -v / bind mount.
    # -------------------------------------------
    FROM base AS mount
    WORKDIR /workspace
    # We do NOT copy the local files here.
    # If you bind mount -v $(pwd):/workspace at runtime, you'll see them inside the container.
    # Everything else from `base` is inherited (Terraform, Terragrunt, tofu).


    # -------------------------------------------
    # 4) Stage named "copy" (if WORKSPACE_MODE=copy).
    #    Copies local directory into /workspace at build time.
    # -------------------------------------------
    FROM base AS copy
    WORKDIR /workspace
    # Copy everything from your current directory (where Dockerfile resides) into /workspace
    COPY . /workspace


    # -------------------------------------------
    # 5) Finally, pick which stage is used based on the build arg
    #    WORKSPACE_MODE. It must match the stage name: "mount" or "copy".
    # -------------------------------------------
    FROM ${WORKSPACE_MODE} AS final

    # Copy your already-installed binaries from the base stage
    COPY --from=base /usr/local/bin/terragrunt /usr/local/bin/terragrunt
    COPY --from=base /usr/local/bin/tofu       /usr/local/bin/tofu

    # (Optional) set a default WORKDIR
    WORKDIR /workspace

    # Entrypoint or CMD as needed
    ENTRYPOINT ["/bin/bash"]
