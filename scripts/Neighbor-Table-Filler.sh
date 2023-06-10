#!/bin/bash
#to be used with the R730 DUT
tester_l_mac="ec:f4:bb:ef:98:a0"
tester_l_dev="eno1"
tester_r_mac="ec:f4:bb:ef:98:a2"
tester_r_dev="eno2"
tester_r_ipv4="203.0.113.56"
bmr_ipv6_prefix="2001:db8:ce:"
bmr_ipv4_prefix="c000:2"
ipv4_suffix_length=8
psid_length=5
ip neighbor add $tester_r_ipv4 lladdr $tester_r_mac dev $tester_r_dev nud permanent
for (( suffix=0 ; suffix < $((2**$ipv4_suffix_length)) ; suffix++ ))
do
    EA=0x0000
    EA=$(( $EA|$suffix ))
    EA=$(( $EA<<$psid_length ))
    for (( psid=0 ; psid < $((2**$psid_length)) ; psid++ ))
    do
        EA_bits=$(( $EA|$psid ))
        end_user_ipv6_prefix=$bmr_ipv6_prefix$(printf '%04x' $EA_bits)
        #echo $end_user_ipv6_prefix
        interface_id=":0000:"$bmr_ipv4_prefix$(printf '%02x:' $suffix)$(printf '%04x' $psid)
        MAP_address=$end_user_ipv6_prefix$interface_id
        #echo $MAP_address
        ip neighbor add $MAP_address lladdr $tester_l_mac dev $tester_l_dev nud permanent
    done
    
done
