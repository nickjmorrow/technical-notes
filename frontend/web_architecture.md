# Web Architecture

Source: https://engineering.videoblocks.com/web-architecture-101-a3224e126947

## DNS

- Domain Name System
- Provides key/value lookup for a domain name (google.com) and IP address (85.129.83.120)
- "Call Jane Done" vs "Call 201-867-5309"
- Phone book for the internet

## Load Balancer

- Horizontal scaling = adding more machines, servers
- Vertical scaling = Adding more CPU, RAM to one server
- For web, always scale horizontally because stuff can break
- Makes scaling horizontally possible. Route incoming requests to one of many application servers

## Web Application Server

- Execute core business logic that handles a user's request and sends back HTML or data to the browser

## Database Server

- NoSQL, SQL

## Caching Service

- Redis, Memcache
- Reduce cost of expensive queries
- Server-side rendering of HTML

## Job Queue & Servers

- Two components:
  _ Queue of jobs that need to be run
  _ One or more job servers (often called "workers") that run the jobs in the queue

## Full-text Search Service

- Elasticsearch
- MySQL supports full-text search
- Leverages an `inverted index` to quickly look up documents that contain the query keywords

## Services

- Account service, content service, payment service, HTML -> PDF service

## Data

- storing information about user clicks
- AWS Kinesis, Redshift

## Cloud Storage

- AWS S3

## CDN

- Content Delivery Network
- Serves assets like static HTML, CSS, Javascript, and images over the web much faster than serving from a central origin server
