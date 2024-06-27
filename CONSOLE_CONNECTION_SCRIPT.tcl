# this is connection script

set extensiondistance 2.0

if {[hm_entityinfo exist components "RBSPRCON_RIGID"] == 0} {
			
			*collectorcreateonly components "RBSPRCON_RIGID" "" 3
	    } 
		   



# proc {} {
#NODES SELECTION SET 1

*createmarkpanel nodes 2 "SELECT NODE SET 1"
set rigidall1 [hm_getmark nodes 2]
set node1set [lindex $rigidall1 0]
*entitysetcreate "depnode1set" nodes 2


#rigid create
*rigidlinkinodecalandcreate 2 0 1 123456


*createmark nodes 1 -1
set rigidcenter1 [hm_getmark nodes 1]

*createmark elems 1 -1
set rigid1 [hm_getmark elems 1]

*tagcreate nodes $rigidcenter1 "dN2" "" 4

*clearmark nodes 1
*clearmark nodes 2
*clearmark elems 1

# }

# proc {} {
#NODES SELECTION SET 2

*createmarkpanel nodes 2 "SELECT NODE SET 2"

set rigidall2 [hm_getmark nodes 2]
set node2set [lindex $rigidall2 0]
*entitysetcreate "depnode2set" nodes 2


#rigid create
*rigidlinkinodecalandcreate 2 0 1 123456

*createmark nodes 1 -1
set rigidcenter2 [hm_getmark nodes 1]

*createmark elems 1 -1
set rigid2 [hm_getmark elems 1]

#*tagcreate nodes $rigidcenter2 "rigidcenter2_$rigidcenter2" "" 4

*clearmark nodes 1
*clearmark nodes 2





# GENERATE NODES BETWEEN
*createnodesbetweennodes $rigidcenter1 $rigidcenter2 2



# GENERATE mid nodes id
 *createmark nodes 1 -1
 set sn1 [hm_getmark nodes 1]
 *clearmark nodes 1
# *tagcreate nodes $sn1 "sn1_$sn1" "" 4
 
  *createmark nodes 1 -2
 set sn2 [hm_getmark nodes 1]
*clearmark nodes 1
 *clearmark nodes 1
 *tagcreate nodes $sn2 "dN1" "" 6


# GENERATE SPRING
*spring $sn1 $sn2 1 "" 0

*createmark elems 1 -1
set spring1 [hm_getmark elems 1]

if {[hm_entityinfo exist components "RBSPRCON_SPRING"] == 0} {
			
			*collectorcreateonly components "RBSPRCON_SPRING" "" 4
	    } 

*createmark elems 1 $spring1
*movemark elems 1 "RBSPRCON_SPRING" 

#FOR FINDING DIRECTION

set dir1 [hm_getdirectionpanel "Please define a direction"]


set dirlist1 [lindex $dir1 0]

set x1 [lindex $dirlist1 0]

set y1 [lindex $dirlist1 1]

set z1 [lindex $dirlist1 2]






#finding translated distance between 1st node of spring and 1st set of rigid

*createmark nodes 1 $rigidcenter1  
*createmark nodes 2 $sn2

set ddata1 [eval hm_measureshortestdistance nodes 1 0 nodes 2 0 0]

set distance1 [lindex $ddata1 0]

set td1 [expr {$distance1 + $extensiondistance}]

*clearmark nodes 1
*clearmark vectors 1

#translate SPRING NODES 1

*createmark nodes 1 $sn2
*createvector 1 $x1 $y1 $z1
*translatemark nodes 1 1 $td1

*createmark nodes 1 $sn1
*createvector 1 $x1 $y1 $z1
*translatemark nodes 1 1 -$td1








# MOVE RIGIDS INTO  component RBSPRCON_RIGID




# MOVE RIGIDS INTO  component RBSPRCON_RIGID



*clearmark nodes 1
*clearmark nodes 2

*clearmark elems 1
*clearmark elems 2

*clearmark vectors 1
*clearmark vectors 2

*clearmark tags 1
*createmark tags 1 all
*deletemark tags 1 

# 1stnode update

*createmark nodes 2 "by set name" depnode1set 
*appendmark  nodes 2 $sn2
*rigidlinkinodecalandcreate 2 0 1 123456

*createmark elems  1 -1
set updated_rigid1 [hm_getmark elems 1]
*clearmark nodes 2 

*createmark nodes 2 "by set name" depnode2set 
*appendmark  nodes 2 $sn1
*rigidlinkinodecalandcreate 2 0 1 123456

*createmark elems  1 -1
set updated_rigid2 [hm_getmark elems 1]



*clearmark nodes 2 


*createmark elems 1 $rigid1 $rigid2
*deletemark elems 1
*clearmark nodes 1

*createmark sets 1 "depnode2set" "depnode1set"
*deletemark sets 1
*clearmark sets 1


*createmark elems 1 $updated_rigid1 $updated_rigid2
*movemark elems 1 "RBSPRCON_RIGID" 
 #}