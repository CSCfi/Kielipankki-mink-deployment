# Kielipankki-mink-deployment
Testing stage Mink deployment

## `docker/mink/`

After supplying `id_rsa`, `id_rsa.pub` and `pubkey.pem`, you can try a local deployment with

`docker build . -t mink:latest && docker run -p 5173:5173 -p 9000:9000 mink:latest`
