# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image — uCore (Fedora CoreOS with batteries included)
FROM ghcr.io/ublue-os/ucore:stable

## [IM]MUTABLE /opt
## Some packages write to /opt during install. On bootc images /opt is normally
## a symlink to /var/opt (mutable), which gets wiped on deployment. Making /opt
## a real directory keeps package contents immutable and persistent.
RUN rm /opt && mkdir /opt

### MODIFICATIONS
## The build script installs all packages, enables COPRs, creates sysusers.d/
## tmpfiles.d drop-ins, applies Nova branding, and enables systemd services.
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh

### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
