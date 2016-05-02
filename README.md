# circle-env

[![Circle CI](https://circleci.com/gh/circleci/circle-env.svg?style=svg)](https://circleci.com/gh/circleci/circle-env)

## What is this?

`circle-env` is a collection of bash scripts that abstracts the way custom software to be installed on CircleCI container. It provides a simple interface: `circle-env install` and it will take care of trivial things such as OS version, where to get the package from, etc.

## Project Status

This project is still under heavy development and not officially supported by CircleCI. Please create a Github issue if you find bugs.

## Install

Add the following lines to your circle.yml

```
machine:
  pre:
    - curl -sSL https://s3.amazonaws.com/circle-downloads/install-circle-env.sh | bash
```

## Usage

```
circle-env install <package> <version>
```

`<package>` is the name of the package that you want to install. `<version>` is the version of the package. `<version>` is optional and the default version of the package will be used if not specified.


Example:

```
circle-env install google-chrome 50
```

This will install Google Chrome v50.

## Development

The actual scripts must be stored under `src/scripts/<distro>`. Currently there are three `<distro>` directories.

`trusty`: scripts that must be compatible with [CircleCI Ubuntu 14.04](https://circleci.com/docs/build-image-trusty/) build image.

`precise`: scripts that must be compatible with [CircleCI Ubuntu 12.04](https://circleci.com/docs/build-image-precise/) build image.

`common`: scripts that must be compatible both with trusty and precise build images.

### Build

When you run `./build.sh` it will compile all scripts under `src/scripts/<distro>` into big `circle-env-precise` and `circle-env-trusty` scripts.

### Hosting Files

CircleCI AWS S3 bucket is the best place to host files that need to be downloaded in your scripts. Please create a Github issue if you have files to upload.

### Test (manually)

Because the scripts are meant to be run on CircleCI build images, they may be broken when you run on your local Linux box.


The best way to test locally is using Docker. Here is how you can build the Docker image and test locally.

```
$ docker build -t circle-env-test .
$ docker run -it -v <path-to-circle-env>:/tmp/circle-env circle-env-test bash
```

Once you are in the Docker container, you can build and test the scripts.

```
$ cd /tmp/circle-env
$ ./build.sh
$ ./dist/circle-env-trusty
```

You can modify the scripts locally and the scripts in the container will be updated since the directory is mounted into the container. Just remember to run `./build.sh` every time you make changes.

**Note:**
the procedures only work for Trusty since CircleCI doesn't have a Precise Docker image to test. If you want to test Precise, the best way is [ssh](https://circleci.com/docs/ssh-build/) into a CircleCI container.

### Test (automatically)

Please write tests when you add new scripts. There are [bats](https://github.com/sstephenson/bats) tests under `tests/` directory.

To run the tests

```
$ docker build -t circle-env-test .
$ docker run circle-env-test bats /home/ubuntu/tests/chrome.bats
```
