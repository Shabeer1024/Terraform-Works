webapp_environment = {
  "production" = {
    serviceplan={
        serviceplan500090={
        sku="S1"
        os_type="Windows"
        }
    }
    serviceapp={
        webapp5000040030="serviceplan500090"
        webapp5000030020="serviceplan500090"
    }
  }
}
  resource_tags = {
    tags = {
        department = "Logistics"
        tier = "Tier2"
    }
  }