build:
	docker build --target base -t my-sports-frontend-base .

test:
	docker run -it --rm my-sports-frontend-base npm test

test-ci:
	docker run -it --rm --env CI=true my-sports-frontend-base npm test

console:
	docker run -it --rm my-sports-frontend-base sh

audit:
	docker run -it --rm --env CI=true my-sports-frontend-base npm audit --production

build-release:
	docker build --target release -t my-sports-frontend-release \
	--build-arg BACKEND_URL=${BACKEND_URL} \
	--build-arg STRAVA_CLIENT_ID=${STRAVA_CLIENT_ID} \
	--build-arg BUILD_DATE=${BUILD_DATE} \
	.

run-release:
	docker run -it --rm -p 5000:5000 my-sports-frontend-release

console-release:
	docker run -it --rm -p 5000:5000 my-sports-frontend-release sh
