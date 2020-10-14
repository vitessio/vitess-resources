# Hint: how to fetch zookeper from apache.org

version=${ZK_VERSION:-3.4.14}
zk="zookeeper-$version"
wget "https://archive.apache.org/dist/zookeeper/$zk/$zk.tar.gz"
