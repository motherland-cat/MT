#!bin/rails runner

$result = []

def separate_text(text)
  a = text.index("/system/pictures/")
  if a.nil?
    return []
  end
  delimitor = text[a-1]
  if delimitor != '\'' and delimitor != '"'
    $result.append("Error 0 with " + text)
    return []
  end
  b = a
  while (b < text.size and text[b] != delimitor) do
    b = b + 1
  end
  if b == text.size
    $result.append("Error 1 with " + text)
    return []
  end
  return [text[0..(a-1)], text[a..(b-1)], text[b..-1]]
end

def detect_picture_id(old_url)
  if old_url.index("/system/pictures/") != 0
    $result.append("Error 2 with " + old_url)
    return -1
  end
  a = "/system/pictures/".size
  b = a
  while (b < old_url.size && old_url[b].match?(/[[:digit:]]/)) do
    b = b + 1
  end
  if b == a
    $result.append("Error 3 with " + old_url) 
    return -1
  end
  return old_url[a..(b-1)].to_i
end

def get_new_url(picture_id)
  p = Picture.find_by_id(picture_id)
  if p.nil?
    $result.append("Error 4 with " + picture_id.to_s)
    return ""
  end
  
  return Rails.application.routes.url_helpers.rails_blob_url(p.image, only_path: true)
end

def replace_one_url(text)
  x = separate_text(text)
  if x == []
    return nil
  end
  old_url = x[1]
  picture_id = detect_picture_id(old_url)
  if picture_id == -1
    return nil
  end
  new_url = get_new_url(picture_id)
  if new_url.size == 0
    return nil
  end
  $result.append("Replacing " + old_url + " by " + new_url)
  return x[0] + new_url + x[2]
end

def replace_all_urls_in_text(text)
  ret = 0
  while true do
    new_text = replace_one_url(text)
    if new_text.nil?
      break
    else
      ret = ret + 1
      text = new_text
    end
  end
  if ret
    return [ret, text]
  else
    return [0, nil]
  end
end

def replace_all_urls_in_object(object, att)
  text = object.read_attribute(att)
  res = replace_all_urls_in_text(text)
  if res[0] == 0
    return 0
  else
    object.update_attribute(att, res[1])
    return res[0]
  end
end

def replace_all_urls_in_model(model, att)
  res = 0
  model.find_each do |object|
    res = res + replace_all_urls_in_object(object, att)
  end
  $result.append("Found " + res.to_s + " urls in attribute " + att + " of " + model.to_s)
  return res
end

def replace_all_urls_on_mathraining
  res = 0
  res = res + replace_all_urls_in_model(Actuality, "content")
  res = res + replace_all_urls_in_model(Theory, "content")
  res = res + replace_all_urls_in_model(Question, "statement")
  res = res + replace_all_urls_in_model(Question, "explanation")
  res = res + replace_all_urls_in_model(Problem, "statement")
  res = res + replace_all_urls_in_model(Problem, "explanation")
  res = res + replace_all_urls_in_model(Contestproblem, "statement")
  res = res + replace_all_urls_in_model(Section, "description")
  res = res + replace_all_urls_in_model(Chapter, "description")
  res = res + replace_all_urls_in_model(Contest, "description")
  res = res + replace_all_urls_in_model(Privacypolicy, "content")
  $result.append("Found " + res.to_s + " urls in total")
end
