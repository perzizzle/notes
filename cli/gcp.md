``` 
gcloud auth application-default login
gcloud auth login
gcloud config set project devint
gcloud compute ssh --project=devint --zone=us-central1-a hostname --internal-ip
```
