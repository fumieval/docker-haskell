# Dockerfile template for Cabal projects

```
./gen.sh EXECUTABLE_NAME
```

Copy `docker.cabal.config` to your project root.

You may need to add runtime resources by adding a line like

```
COPY runtime/ /app/runtime/
```