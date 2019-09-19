## This is only a reference as documentation of a call manually made to the API for now.

PUT /_template/kube-audit
{
  "index_patterns": ["*kube-audit*"],
  "order" : 100,
  "mappings": {
    "doc": {
      "dynamic_templates": [
        {
          "default_no_index": {
            "path_match": "^(objectRef.*|requestObject.*)",
            "match_pattern": "regex",
            "mapping": {
              "index": false,
              "enabled": false,
              "dynamic": false
            }
          }
        }
      ]
    }
  }
}