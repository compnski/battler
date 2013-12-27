<?xml version="1.0" encoding="UTF-8"?>
<tileset name="markers" tilewidth="32" tileheight="32">
 <image source="markers.png" trans="ffffff" width="64" height="32"/>
 <terraintypes>
  <terrain name="FriendlySpawn" tile="0">
   <properties>
    <property name="faction" value="player"/>
   </properties>
  </terrain>
  <terrain name="EnemySpawn" tile="1">
   <properties>
    <property name="faction" value="enemy"/>
   </properties>
  </terrain>
 </terraintypes>
 <tile id="0" terrain="0,0,0,0">
  <properties>
   <property name="tileprop" value="green"/>
  </properties>
 </tile>
 <tile id="1" terrain="1,1,1,1"/>
</tileset>
