--Library for interfacing with p.sc3.io

local function init(token)
  return {
    create=function(content,name,language,expires,visibility,password)
      local headers=(token and {Authorization="Bearer "..token,["Content-Type"]="application/json"} or {["Content-Type"]="application/json"})
      local res=http.post("https://p.sc3.io/api/v1/pastes",textutils.serializeJSON({content=content,name=name,language=language,expires=expires,visibility=visibility,password=password}),headers,true)
      if not res or (type(res.getResponseCode)=="function" and res.getResponseCode() or nil)~=201 then print("ERROR: Failed to create paste") return false,res end
      if (type(res.getResponseCode)=="function" and res.getResponseCode() or nil)==201 then return res.readAll() end
      return res --Fallback; spit out what we got
    end, --POST https://p.sc3.io/api/v1/pastes
    update=function(id,content,name,language,expires,visibility,password,passwordEnabled)
      local headers=(token and {Authorization="Bearer "..token,["Content-Type"]="application/json"} or {["Content-Type"]="application/json"})
      local res=http.post("https://p.sc3.io/api/v1/pastes/"..id,textutils.serializeJSON({content=content,name=name,language=language,expires=expires,visibility=visibility,password=password,passwordEnabled=passwordEnabled}),headers,true)
      if not res or (type(res.getResponseCode)=="function" and res.getResponseCode() or nil)~=200 then print("ERROR: Failed to update paste") return false,res end
      if (type(res.getResponseCode)=="function" and res.getResponseCode() or nil)==200 then return res.readAll() end
      return res --Fallback; spit out what we got
    end, --POST https://p.sc3.io/api/v1/pastes/{id}
    read=function(id)
      local headers=(token and {Authorization="Bearer "..token} or nil)
      local res=http.get("https://p.sc3.io/api/v1/pastes/"..id.."/raw",headers,true)
      if res.readAll and type(res.readAll)=="function" and res.getResponseCode and type(res.getResponseCode)=="function" and res.getResponseCode()==200 then
        return res.readAll()
      else
        return res
      end
    end, --GET https://p.sc3.io/api/v1/pastes/{id}/raw
    delete=function(id)
      local headers=(token and {Authorization="Bearer "..token} or nil)
      local res=http.post("http://p.sc3.io/api/v1/pastes/"..id.."/delete","",headers,true)
      if not res or (type(res.getResponseCode)=="function" and res.getResponseCode() or nil)~=200 then print("ERROR: Failed to delete paste") return false,res end
      if (type(res.getResponseCode)=="function" and res.getResponseCode() or nil)==200 then return true end
      return res
    end, --POST https://p.sc3.io/api/v1/pastes/{id}/delete
    metadata=function(id)
      local headers=(token and {Authorization="Bearer "..token} or nil)
      local res=http.get("https://p.sc3.io/api/v1/pastes/"..id,headers,true)
      if res.readAll and type(res.readAll)=="function" and res.getResponseCode and type(res.getResponseCode)=="function" and res.getResponseCode()==200 then
        return res.readAll()
      else
        return res
      end
    end --GET https://p.sc3.io/api/v1/pastes/{id}
  }
end
return init
