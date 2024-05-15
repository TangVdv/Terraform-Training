locals {
    env_tfapi = [ 
        "DB_HOST=db:8060",
        "DB_USER=user",
        "DB_NAME=tfshow",
        "DB_PASSWORD=${random_password.mysql_password.result}"
    ]

    env_tfshow = [ 
        "VITE_API_URL=http://localhost:8080",
        "VITE_WEBSITE_URL=http://localhost:8000"
    ]

    ngix-container = [
        {
            "name" = "server-backend-api"
            "hostname" = "tfshowapi"
            "restart" = "always"
            "volume_name" = "${docker_volume.tfapi_volume.name}"
            "volume_path" = "/usr/share/nginx/html/"
            "external_port" = 8080
            "env" = "${local.env_tfapi}"
        },
        {
            "name" = "server-tfshow"
            "hostname" = "tfshow"
            "restart" = "on-failure"
            "volume_name" = "${docker_volume.tfshow_volume.name}"
            "volume_path" = "/usr/share/nginx/html/"
            "external_port" = 8000
            "env" = "${local.env_tfshow}"
        }
    ]
    
}