# docker-watch
This is very basic repo for setting up node app and docker with --wait and --watch mode

Once you clone repository:

Run following commands one after another

``docker compose up --build --wait``

``docker compose alpha watch``

After that, try changing any files and you will notice changes right inside the container.
