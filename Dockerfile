FROM postgres:16

LABEL author="MocóGroup"
LABEL description="Banco de dados personalizado com schema inicial do Roomie"

COPY ./scripts/ /docker-entrypoint-initdb.d/