#!/bin/bash

#-----------------------|DOCUMENTATION|-----------------------#
# @descr:
# @fonts: https://github.com/coreos/etcd/blob/master/Documentation/dev-guide/interacting_v3.md
#         https://coreos.com/etcd/docs/latest/demo.html
#         https://coreos.com/etcd/docs/latest/op-guide/clustering.html  
#         https://coreos.com/etcd/docs/latest/v2/clustering.html
#         https://stackoverflow.com/questions/37089387/coreos-member-node-will-not-start-when-using-etcdctl-member-add
#         https://github.com/coreos/etcd/issues/7436
#-------------------------------------------------------------#

# @descr: Main function of the script, it runs automatically on the script call.
# @param: 
#    $@ | array: (*)
function StartConfiguration {
    local PRIVATE_IPV4="${1}";
    local DISCOVERY="${2}";
    local HOSTNAME="${3}";

    printf '%b\n' "Initializing the (ETCD) configuration on the system...";
    printf '%b\n' "--> Private IP: ${PRIVATE_IPV4}";
    printf '%b\n' "--> Name Server ETCD: ${HOSTNAME}";

    local etcdMemberPath="/etc/systemd/system/etcd-member.service.d";
    local etcdMemberConfFile="etcd-member.conf";

    mkdir -p "${etcdMemberPath}";
    touch "${etcdMemberPath}/${etcdMemberConfFile}"
    {
        # @descr: Starting a certain cluster number by DISCOVERY.
        echo '[Service]';
        echo 'ExecStart=';
        echo 'ExecStart=/usr/lib/coreos/etcd-wrapper $ETCD_OPTS \';
        echo '  --name="'${HOSTNAME}'" \';
        echo '  --advertise-client-urls="http://'${PRIVATE_IPV4}':2379" \';
        echo '  --listen-client-urls="http://0.0.0.0:2379,http://0.0.0.0:4001" \';
        echo '  --listen-peer-urls="http://'${PRIVATE_IPV4}':2380" \';
        echo '  --initial-advertise-peer-urls="http://'${PRIVATE_IPV4}':2380" \';
        echo '  --discovery="'${DISCOVERY}'"';

        # OR...

        # @descr: A predefined cluster!!!
        #echo '[Service]';
        #echo 'ExecStart=';
        #echo 'ExecStart=/usr/lib/coreos/etcd-wrapper $ETCD_OPTS \';
        #echo '  --name="'${HOSTNAME}'" \';
        #echo '  --advertise-client-urls="http://'${PRIVATE_IPV4}':2379" \';
        #echo '  --listen-client-urls="http://0.0.0.0:2379,http://0.0.0.0:4001" \';
        #echo '  --listen-peer-urls="http://'${PRIVATE_IPV4}':2380" \';
        #echo '  --initial-advertise-peer-urls="http://'${PRIVATE_IPV4}':2380" \';
        #echo '  --initial-cluster="coreos-1-etcd=http://192.168.33.101:2380,coreos-2-etcd=http://192.168.33.102:2380,coreos-3-etcd=http://192.168.33.103:2380" \';
        #echo '  --initial-cluster-token="Unique-token-for-ETCD-group" \';
        #echo '  --initial-cluster-state="new"';

        # ADD MEMBER...

        # @descr: Adding members(ETCD) to a particular cluster.
        # @fonts: https://coreos.com/etcd/docs/latest/etcd-live-cluster-reconfiguration.html#change-etcd-cluster-size
        #echo '[Service]';
        #echo 'ExecStart=';
        #echo 'ExecStart=/usr/lib/coreos/etcd-wrapper $ETCD_OPTS \';
        #echo '  --name="'${HOSTNAME}'" \';
        #echo '  --advertise-client-urls="http://'${PRIVATE_IPV4}':2379" \';
        #echo '  --listen-client-urls="http://0.0.0.0:2379,http://0.0.0.0:4001" \';
        #echo '  --listen-peer-urls="http://'${PRIVATE_IPV4}':2380" \';
        #echo '  --initial-advertise-peer-urls="http://'${PRIVATE_IPV4}':2380" \';
        #echo '  --initial-cluster="coreos-1-etcd=http://192.168.33.101:2380,coreos-2-etcd=http://192.168.33.102:2380,coreos-3-etcd=http://192.168.33.103:2380,coreos-4-etcd=http://192.168.33.104:2380" \';
        #echo '  --initial-cluster-state="existing"';

    } > "${etcdMemberPath}/${etcdMemberConfFile}";
    chmod 644 ${etcdMemberPath}/${etcdMemberConfFile};

    systemctl daemon-reload;
    systemctl enable etcd-member;
} 

# @descr: Call of execution of the script's main function.
StartConfiguration "$@";

# @descr: Finishing the script!!! :P
exit 0;
