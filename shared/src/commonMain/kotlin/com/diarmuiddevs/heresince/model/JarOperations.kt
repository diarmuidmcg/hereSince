package com.diarmuiddevs.heresince.model

import com.diarmuiddevs.heresince.model.entity.Jar

class JarOperations {
    fun readTag() {
//        use nfc to get UID
        val jarUid = "04C6E41AE66C80"
//        send UID to backend
        val jar = JarRepository().findJarById(jarId = jarUid)

    }

    fun determineJarDetails(jar: Jar): ReadTagResponse {
        //        return readTagResponse
        return if (jar == null) ReadTagResponse(type = ResponseToJar.NOTREGISTERED, response = Jar())
        else if (jar.jarContentName == "") ReadTagResponse(type = ResponseToJar.JARNODATA, response = Jar())
        else ReadTagResponse(type = ResponseToJar.JARHASDATA, response = jar)
    }


}


// this all may be used on backend too, will determine
enum class ResponseToJar { JARHASDATA,JARNODATA,NOTREGISTERED}

class ReadTagResponse(
    type: ResponseToJar,
    response: Jar
)