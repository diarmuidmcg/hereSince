package com.diarmuiddevs.heresince.model

import com.diarmuiddevs.heresince.model.entity.Jar

class JarOperations {
    fun readTag() {
//        use nfc to get UID
        val jarUid = "04C6E41AE66C80"
//        send UID to backend
//        val jar = findJarById(jarId = jarUid)

    }

    fun determineJarDetails(jar: Jar): JarOverview {
        //        return readTagResponse
        return if (jar == null) JarOverview(JARTYPE.NOTREGISTERED,Jar())
        else if (jar.jarContentName == "") JarOverview(type = JARTYPE.JARNODATA, jar = Jar())
        else JarOverview(type = JARTYPE.JARHASDATA, jar = jar)
    }


}


// this all may be used on backend too, will determine
enum class JARTYPE { JARHASDATA,JARNODATA,NOTREGISTERED}

open class JarOverview(
    val type: JARTYPE,
    val jar: Jar
)