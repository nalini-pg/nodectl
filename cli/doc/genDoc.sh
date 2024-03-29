export pgeMdDir=$PGE/cli/doc
export nc=../../out/posix/pgedge

um () {
$nc um --help
$nc um list                 --help
$nc um update               --help
$nc um install              --help
$nc um remove               --help
$nc um upgrade              --help
$nc um clean                --help
}

service () {
$nc service --help
$nc service start           --help
$nc service stop            --help
$nc service status          --help
$nc service reload          --help
$nc service restart         --help
$nc service enable          --help
$nc service disable         --help
$nc service config          --help
$nc service init            --help
}

spock () {
$nc spock --help
$nc spock node-create       --help
$nc spock node-drop         --help
$nc spock node-alter-location --help
$nc spock node-list           --help
$nc spock node-add-interface  --help
$nc spock node-drop-interface --help
$nc spock repset-create     --help
$nc spock repset-alter      --help
$nc spock repset-drop       --help
$nc spock repset-add-table  --help
$nc spock repset-remove-table --help
$nc spock repset-add-seq    --help
$nc spock repset-remove-seq --help
$nc spock repset-list-tables  --help
$nc spock repset-add-partition --help
$nc spock repset-remove-partition --help
$nc spock replicate-ddl     --help
$nc spock sequence-convert  --help
$nc spock sub-create        --help
$nc spock sub-drop          --help
$nc spock sub-alter-interface --help
$nc spock sub-enable        --help
$nc spock sub-disable       --help
$nc spock sub-add-repset    --help
$nc spock sub-remove-repset --help
$nc spock sub-show-status   --help
$nc spock sub-show-table    --help
$nc spock sub-resync-table  --help
$nc spock sub-wait-for-sync --help
$nc spock table-wait-for-sync --help
$nc spock health-check      --help
$nc spock metrics-check     --help
$nc spock set-readonly      --help
}

db () {
$nc db --help
$nc db create               --help
$nc db guc-set              --help
$nc db guc-show             --help
$nc db dump                 --help
$nc db restore              --help
$nc db migrate              --help
}

cluster () {
$nc cluster --help
$nc cluster local-create      --help
$nc cluster local-destroy     --help
$nc cluster remote-init       --help
$nc cluster remote-reset      --help
$nc cluster remote-import-def --help
$nc cluster command           --help
$nc cluster app-install       --help
$nc cluster app-remove        --help
}

cloud () {
$nc cloud --help
$nc cloud config             --help
$nc cloud list-linked-accts  --help
$nc cloud list-clusters      --help
$nc cloud cluster-status     --help
$nc cloud list-nodes         --help
$nc cloud import-cluster-def --help
$nc cloud get-cluster-id     --help
$nc cloud get-node-id        --help
$nc cloud push-metrics       --help
$nc cloud create-cluster     --help
$nc cloud destroy-cluster    --help
}

ace () {
$nc ace --help
$nc ace table-diff          --help
$nc ace diff-schema         --help
$nc ace diff-spock          --help
$nc ace table-repair        --help
$nc ace table-rerun         --help
$nc ace repset-diff         --help
}

firewalld () {
$nc firewalld --help
$nc firewalld list          --help
$nc firewalld add           --help
$nc firewalld remove        --help
}

multicloud () {
$nc multicloud list-providers       --help
$nc multicloud list-airport-regions --help
$nc multicloud list-zones           --help
$nc multicloud list-nodes           --help
$nc multicloud list-sizes           --help
$nc multicloud create-node          --help
$nc multicloud start-node           --help
$nc multicloud stop-node            --help
$nc multicloud reboot-node          --help
$nc multicloud destroy-node         --help
$nc multicloud cluster-create       --help
}


############## MAINLINE ############################
if [ $# -ne 1 ]; then
  echo "ERROR: must be one 'module' parameter"
  exit 1
fi

m=$1
if [ $m == "all" ]; then
  um
  service
  spock
  db
  cluster
  cloud
  ace
  multicloud
  firewalld
elif [ $m == "um" ]; then
  um
elif [ $m == "service" ]; then
  service
elif [ $m == "spock" ]; then
  spock
elif [ $m == "db" ]; then
  db
elif [ $m == "cluster" ]; then
  cluster
elif [ $m == "cloud" ]; then
  cloud
elif [ $m == "ace" ]; then
  ace
elif [ $m == "multicloud" ]; then
  multicloud
elif [ $m == "firewalld" ]; then
  firewalld
else
  echo "ERROR: $m is not a valid module"
  exit 1
fi

exit 0


cloud


