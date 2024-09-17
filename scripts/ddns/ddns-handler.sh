#!/bin/bash

get_public_ip() {
    public_ip=$(curl -s https://api.ipify.org)
    
    if [ $? -eq 0 ]; then
        echo "Your public IP address is: $public_ip"

        curl -X PUT "https://napi.arvancloud.ir/cdn/4.0/domains/thepooyan.ir/dns-records/f5aca433-cb4e-48af-af54-9236aa55ef2b" \
             -H "Authorization: $(pass show tokens/abr-arvan)" \
             -H "Content-Type: application/json" \
             -d '{
                  "value": [
                    {
                      "ip": "'$public_ip'",
                      "port": 1,
                      "weight": 1000,
                      "country": "US"
                    }
                  ],
                  "type": "a",
                  "name": "string",
                  "ttl": 120,
                  "cloud": false,
                  "upstream_https": "default",
                  "ip_filter_mode": {
                    "count": "single",
                    "order": "none",
                    "geo_filter": "none"
                  }
                  }'
    else
        echo "Failed to retrieve public IP address."
    fi
}

get_public_ip
