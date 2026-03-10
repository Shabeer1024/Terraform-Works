data "local_file" "locals" {
  filename = "local.tf"
}

output "filedetails" {
  value = data.local_file.locals.content
}