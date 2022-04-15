# Hint: how to fetch zookeper from apache.org

version=${ZK_VERSION:-3.8.0}
zk="zookeeper-$version"
wget "https://dlcdn.apache.org/zookeeper/$zk/apache-$zk.tar.gz"
