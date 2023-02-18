.PHONY: clean build compose

clean:
	rm -rf ./data/*
	rm -rf ./dist/*
	rm -rf ./data/.*
	rm -rf ./dist/.*

build:
	mkdir -p dist && cd dist && sudo rm -rf ./toree && git clone -b scala2.13 --depth=1 https://github.com/requaos/incubator-toree.git toree && cd toree && make release && sudo rm -rf ../../artifacts/toree-pip && mv dist/toree-pip ../../artifacts/ && cd .. && sudo rm -rf ./toree	
	sbt -Dsbt.ivy.home=./dist/ publishLocal

compose:
	docker-compose up --build