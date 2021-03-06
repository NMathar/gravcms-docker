# Grav Docker Container

Thanks to https://github.com/benjick for his great work! Here https://hub.docker.com/r/benjick/grav/

## Usage

### First way

A folder called `user` will be created in the same folder as you are running this (if it doesn't exist already). You can then develop in this folder.

```bash
# Start the container in the background, mapping port 3030 to your Grav container
docker run \
  -v $(pwd)/user:/var/www/html/user \
  -p 3030:80 \
  --name mygrav -d nmonst4/gravcms-docker
# Installs the default theme 'antimatter'
docker exec --user www-data mygrav bin/gpm install antimatter
```

Now you can go to localhost:3030 and see your page in action.

```bash
# start with a skeleton
git clone https://github.com/getgrav/grav-skeleton-twenty-site ./user
rm -rf ./user/.git
docker run \
  -v $(pwd)/user:/var/www/html/user \
  -p 3030:80 \
  --name mygrav -d nmonst4/gravcms-docker
```

### Second way

If you want to push your app to a registry this might be what your `Dockerfile` looks like

```
FROM nmonst4/gravcms-docker:latest
COPY ./user /var/www/html/user
```

and to run it

```bash
docker build -t myapp .
docker run -p 3030:80 --name mygrav -d myapp
```

Where `user` is the user-folder for your Grav site

#### For Mac

https://github.com/adlogix/docker-machine-nfs

## Build from Repo 

Clone Repo and navigate into the repo folder.

### Build
```bash
docker build -t myapp .
```

### Run
```bash
docker run -p 3030:80 --name mygrav -d myapp
```
