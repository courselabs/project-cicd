# CI/CD Pipeline Project

This project is your chance to spend some dedicated time building out a CI/CD pipeline of your own.

You'll use all the key skills you've learned, and:

- 😣 you will get stuck
- 💥 you will have errors and broken apps
- 📑 you will need to research and troubleshoot

**That's why the project is so useful!** 

It will help you understand which areas you're comfortable with and where you need to spend some more time.

And it will give you a pipeline that you built yourself, which you can use as a reference when you need to add CI/CD to a real project.

> ℹ There are multiple parts to the project - you're not expected to complete them all. Just get as far as you can in the time, it's all great experience.

## Part 1 - Welcome to Widgetario

Widgetario is a company which sells gadgets. They want to run their public web app in a cloud native platform. They've settled on Kubernetes, so the first step is to build some container images for the application components. 

Here's the application architecture:

![](/img/widgetario-architecture.png)

There are four components to the app, each will need its own Docker image. The source code is in the `project/src` folder, and each component has a Dockerfile which needs to be completed in the `project/docker` folder:

- Products database - a Postgres database, built with some sample data ([db/Dockerfile](./project/docker/db/Dockerfile))

- Products API - a Java REST API which reads from the Products database ([products-api/Dockerfile](./project/docker/products-api/Dockerfile))

- Stock API - a Go REST API which also reads from the Products database ([stock-api/Dockerfile](./project/docker/stock-api/Dockerfile))

- Website - an ASP.NET Core website which uses the Products and Stock APIs ([web/Dockerfile](./project/docker/web/Dockerfile))

You should be able to get all the components to build without any errors.

🥅 Goals

- build a Docker image for each component

- verify you can run a container from each image

- every container should print application logs, but may exit with errors - that's OK

- you don't need to run all the containers and test the whole app at this stage

📚 Reference

- we covered the basics in [Building Container Images](https://devsecops.courselabs.co/labs/images/)

- and looked at compiling code with containers in [Multi-stage Builds](https://devsecops.courselabs.co/labs/multi-stage/)

<details>
  <summary>💡 Hints</summary>

We have the source code so you'll want to use multi-stage builds for the application components (except the database).

The build steps are already written in scripts, so your job will be to find the right base images from Docker Hub and copy in the correct folder structure.

Stick to official images :)

</details><br/>

<details>
  <summary>🎯 Solution</summary>

If you didn't get part 1 finished, you can check out the sample solution from `solution/part-1`:

- Products database [Dockerfile](./solution/part-1/docker/db/Dockerfile)

- Products API [Dockerfile](./solution/part-1/docker/products-api/Dockerfile)

- Stock API [Dockerfile](./solution/part-1/docker/stock-api/Dockerfile)

- Website [Dockerfile](./solution/part-1/docker/web/Dockerfile)

Copy from the sample solution to the project directory:

```
mv project/docker project/docker.bak

cp -r solution/part-1/docker project/
```

Then build the images and run containers - make sure you use the project directory as the context so Docker can access the src and docker folders:

_Database_

```
docker build -t widgetario/db -f project/docker/db/Dockerfile ./project

docker run --rm -it widgetario/db

# you should see log entries about tables being created and the database being ready to accept connections

# ctrl-c/cmd-c to exit
```

_Products API_

```
docker build -t widgetario/products-api -f project/docker/products-api/Dockerfile ./project

docker run --rm -it widgetario/products-api

# you should see log entries for the Spring Boot app starting

# then the app errors because it can't find the database and the app exits - this is OK
```

_Stock API_

```
docker build -t widgetario/stock-api -f project/docker/stock-api/Dockerfile ./project

docker run --rm -it widgetario/stock-api

# you should see a log saying the server is starting

# ctrl-c/cmd-c to exit
```

_Website_

```
docker build -t widgetario/web -f project/docker/web/Dockerfile ./project

docker run --rm -it widgetario/web

# you won't see any logs here but the container should stay running

# ctrl-c/cmd-c to exit
```

</details><br/>

## Part 2 - Application Modelling

We've made a good start - all the components are packaged into container images now. Your job is to get it running in Docker Compose so Widgetario can see how it works in a test environment. You should be able to run the app with a simple command and browse to the site on your local machine.

The Compose definition should also include all the build details, so we can build all the images with a single `docker-compose` command. Remember the Compose syntax lets you inject environment variables into values (like image names) which will be useful when we build with Jenkins.

<details>
  <summary>💡 Hints</summary>

The component names in the architecture diagram are the DNS names the app expects to use. It can take 30 seconds or so for all the components to be ready, so you may have to refresh a few times before you see the website.

</details><br/>

When you're done you should be able to browse to http://localhost:8080 and see this:

![](/img/widgetario-solution-1.png)

<details>
  <summary>🎯 Solution</summary>

If you didn't get part 2 finished, you can check out the sample solution from `solution/part-2`:

- [docker-compose.yml](./solution/part-2/compose/docker-compose.yml) - model with variables in the image name

- [build.yml](./solution/part-2/compose/build.yml) - override file with build details


Copy from the sample solution to the project directory:

```
mv project/compose project/compose.bak

cp -r solution/part-2/compose project/
```

Build with the new image tags:

```
docker-compose -f project/compose/docker-compose.yml -f project/compose/build.yml build
```

Run the sample solution:

```
docker-compose -f project/compose/docker-compose.yml up -d
```

Check the app at http://localhost:8080

</details><br/>

## Part 3 - Continuous Integration

- build with Jenkins ("docker compose")

- run with compose in test stage

- curl test(s)
- web /up
- stock /healthz
- products /healthz

Run infra:

```
docker-compose -f infra\build/docker-compose.yml up -d
```


jenkins: http://localhost:8081
gogs: http://localhost:3000

username: courselabs
password: student

```
git remote add project http://localhost:3000/courselabs/labs.git
```


Copy from the sample solution to the project directory:

```
mv project/compose project/compose.bak
mv project/jenkins project/jenkins.bak

cp -r solution/part-3/compose project/
cp -r solution/part-3/jenkins project/
```

```
git add --all

git commit -m 'Part 3 solution'

git push project main
```

Create project in Jenkins

- Git URL = `http://gogs:3000/courselabs/labs.git`
- branch specifier = `refs/heads/main`
- Jenkinsfile path = `project/jenkins/Jenkinsfile`
- Build Now