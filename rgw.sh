sed -i '$a  [client.rgw.node5]' /etc/ceph/ceph.conf
sed -i '$a  host = node5' /etc/ceph/ceph.conf
sed -i '$a  rgw_frontends = \x22civetweb port=8000\x22' /etc/ceph/ceph.conf
systemctl restart ceph-*

