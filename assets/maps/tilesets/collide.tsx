<?xml version="1.0" encoding="UTF-8"?>
<tileset name="playerkill" tilewidth="32" tileheight="32">
 <image source="playerkill.png" trans="ffffff" width="64" height="32"/>
 <terraintypes>
  <terrain name="Collide" tile="1"/>
  <terrain name="Clear" tile="0"/>
 </terraintypes>
 <tile id="0" terrain="1,1,1,1"/>
 <tile id="1" terrain="0,0,0,0">
  <properties>
   <property name="playerkill" value="true"/>
  </properties>
 </tile>
</tileset>
