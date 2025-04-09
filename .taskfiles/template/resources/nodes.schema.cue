package config

import (
	"list"
)

#Config: {
	nodes: [...#Node]
	_nodes_check: {
		name: list.UniqueItems() & [for item in nodes {item.name}]
		mac_addr: list.UniqueItems() & [for item in nodes {item.mac_addr}]
	}
}

#Node: {
	name:          =~"^[a-z0-9][a-z0-9\\-]{0,61}[a-z0-9]$|^[a-z0-9]$" & !="global" & !="controller" & !="worker"
	controller:    bool
	disk:          string
	mac_addr:      =~"^([0-9a-f]{2}[:]){5}([0-9a-f]{2})$"
	schematic_id:  =~"^[a-z0-9]{64}$"
	mtu?:          >=1450 & <=9000
	secureboot?:   bool
	encrypt_disk?: bool
}

#Config
