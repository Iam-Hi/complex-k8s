docker build -t iamhi/multi-client:latest -t iamhi/multi-client:$GIT_SHA -f ./client/Dockerfile ./client
docker build -t iamhi/multi-server:latest -t iamhi/multi-server:$GIT_SHA -f ./server/Dockerfile ./server
docker build -t worker/multi-worker:latest -t iamhi/multi-worker:$GIT_SHA -f ./worker/Dockerfile ./worker

docker push worker/multi-client:latest
docker push worker/multi-server:latest
docker push worker/multi-worker:latest

docker push worker/multi-client:GIT_SHA
docker push worker/multi-server:GIT_SHA
docker push worker/multi-worker:GIT_SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=iamhi/multi-server:$GIT_SHA
kubectl set image deployments/client-deployment client=iamhi/multi-client:$GIT_SHA
kubectl set image deployments/worker-deployment worker=iamhi/multi-worker:$GIT_SHA
