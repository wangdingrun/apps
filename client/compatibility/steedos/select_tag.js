
/*
* 添加Array的remove函数
*/
Array.prototype.remove = function(from, to) {
	if(from < 0 ){
		return ;
	}   
    var rest = this.slice((to || from) + 1 || this.length);   
    this.length = from < 0 ? this.length + from : from;   
    return this.push.apply(this, rest);   
};

/*
* 添加Array的过滤器
* return 符合条件的对象Array
*/
Array.prototype.filterProperty = function(h, l){
	var g = [];
	this.forEach(function(t){
		var m = t ? t[h]:null;
		var d = false;
		if(m instanceof Array){
			d = m.includes(l);
		}else{
			if(m instanceof Object){
				if("id" in m){
					m = m["id"];
				}else if("_id" in m){
					m = m["_id"];
				}

			}
            if(l instanceof Array){
                d = (l === undefined) ? false : l.includes(m);
            }else{
                d = (l === undefined) ? false : m==l;
            }
		}

		if(d){
			g.push(t);
		}
	});
	return g;
}

/*
* 添加Array的过滤器
* return 符合条件的第一个对象
*/
Array.prototype.findPropertyByPK = function(h, l){
	var r = null;
	this.forEach(function(t){
		var m = t ? t[h]:null;
		var d = false;
		if(m instanceof Array){
			d = m.includes(l);
		}else{
			d = (l === undefined) ? false : m==l;
		}

		if(d){
			r = t;
		}
	});
	return r;
}

$(function(){

	if(!$("#selectTagModal").html()){
		$("body").append('<div class="modal fade selectTagModal" id="selectTagModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">  <div class="modal-dialog" role="document"><div class="modal-content">  <div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button><h4 class="modal-title" id="myModalLabel">选择人员</h4>  <div class="modal-footer"><button type="button" class="btn btn-default" data-dismiss="modal">取消</button><button type="button" class="btn btn-primary selectTagOK">确定</button>  </div></div>  <div id="selectTagModal-content"></div></div>  </div></div>');
	}

	if(!$("#selectTagTemplate").html()){
		$("body").append('<script id="selectTagTemplate" type="text/x-handlebars-template">{{#if showOrg}}<div class="box-header with-border">    <ol class="breadcrumb" style="float:left">    {{breadcrumb org}}    </ol></div>{{/if}}<div class="modal-body selectTagModal-body" id="selectTagModal-body">{{#if showOrg}}<div class="box box-solid"><div class="box-body no-padding"><ul class="nav nav-pills nav-stacked">{{#orgList org.children tagType showUser}}{{name}}{{/orgList}}</ul></div></div>{{/if}}{{#if showUser}}{{#if org.users}}<div class="box box-solid"><div class="box-body no-padding"><table id="selectTag-users" class="table table-bordered table-striped selectTag-users" width="100%" style="text-align:left"><thead style="display:none"><tr>  <th data-priority="1">用户姓名</th></tr></thead><tbody>{{#userList org.users tagType}}{{name}}{{/userList}}</tbody></table></div></div>{{/if}}{{/if}}</div></script>');
	}
});


(function (define) {
	define(['jquery'], function ($) {
		return (function(){
			var $options ;
			var selectTag = {
				show : show,
				hide : hide,
				reload : reloadTag,
                checked : checked,
                values :[],
                valuesObject : getValuesObject
			}
			return selectTag;

            function getValuesObject(){
                if($options.showUser){
                    return $options.data.users.filterProperty("id", SelectTag.values);
                }else{
                    return $options.data.orgs.filterProperty("id", SelectTag.values);
                }
            }

            function checked(tag){
                if(tag.type == 'radio'){
                    selectTag.values = [tag.value];
                }else{
                    if(tag.checked){
                        selectTag.values.push(tag.value);
                    }else{
                        selectTag.values.remove(selectTag.values.indexOf(tag.value));
                    }
                }
            }
			/*
			* options : {} 
			* 	data: {orgs:[],users:[]}
			* 	multiple : false 单选，true 多选
			* 	showOrg : 是否显示部门
			* 	showUser : 是否显示用户。true : 用户可选择user 。 false ： 用户可选择 orgs。
			*	orgId : 第一层orgId
            *   org:
			* callback : 点击确认按钮的回调函数
			*/
			function show(options,callback){

                options.values = [];

                if(options.defaultValues && options.defaultValues.length > 0){
                    selectTag.values = options.defaultValues;
                    options.defaultValues = [];
                }
				//检查参数
				checkOptions(options);
				
				initOptions(options);
				
				reloadTag($options.orgId);

                $(".selectTagOK").attr('onclick',callback + ";SelectTag.hide();");

				$("#selectTagModal").modal('show');
			};
			
			function hide(){
				$("#selectTagModal").modal('hide');
			};

			function checkOptions(options){
				if(!options || !options.data)
					throw new Error("缺少参数，eg:show({orgs:[{id:'',name:'',parent:''}],users:[{id:'',name:'',orgs:[]}]})");
				
				return true;
			};
			
			function initOptions(options){
				if(!options.multiple){
					options.multiple = false;
                    options.tagType = 'radio';
				}else{
                    options.tagType = 'checkbox';
                }
				
				if(options.showOrg != false){
					options.showOrg = true;
				}
				
				if(options.showUser != false){
					options.showUser = true;
				}

                if(!options.orgId){
                    options.orgId = '';
                }

                if(options.showOrg && options.data.users){
                    options.data.users.forEach(function(u){
                        if(organizations in u){
                            return ;
                        }
                        if(u.organization instanceof Object){
                            
                        }else{
                            u.organization = options.data.orgs.findPropertyByPK("id", u.organization);
                        }

                        u.organizations = u.organization.parents.concat(u.organization.id);
                    });
                }
				
				$options = $.extend({},options);
			};

			function reloadTag(orgId){
				var options = constructorOptions(orgId);
				var sourceTemplate = $("#selectTagTemplate").html();
				var template = Handlebars.compile(sourceTemplate);
				$('#selectTagModal-content').html(template(options));
                $(".selectTag-profile").initial({charCount:1});
                setDefaultValues(options);
                $("#selectTag-users").DataTable({
                    paging:true,
                    lengthChange:false,
                    searching:false,
                    ordering:false,
                    info:false,
                    autoWidth:true,
                    language:{
                        oPaginate:{
                            sFirst:'首页',
                            sPrevious:'上页',
                            sNext:'下页',
                            sLast:'末页'
                        }
                    }
                });
			};

            function setDefaultValues(options){
                var dfs= selectTag.values;
                dfs.forEach(function(v){
                    $("#" + v).attr("checked",true);
                });
            }

			function constructorOptions(orgId){
                var org = {};
				if($options.showOrg){
                    
                    org = $options.data.orgs.findPropertyByPK("id", orgId);

                    if(org){
                        org.parentOrg = getOrgParent(org.parent);
                    }else{
                        org = {};
                    }

					org.children = getOrgChildren(orgId);
				}
				org.users = getUsers(orgId);

                $options.org = org;

				return $options;
			};

            function getOrgParent(parentOrgId){
                var org ;

                if(parentOrgId == '' || parentOrgId == 0){
                    return ;
                }else{
                    org = $options.data.orgs.findPropertyByPK("id", parentOrgId);
                }

                if(org.parent != '' && org.parent != 0){
                    org.parentOrg = getOrgParent(org.parent);
                }

                return org;
            };
			
			/*
			* return 传入orgId的直属组织
			*/
			function getOrgChildren (orgId){
				var orgChildren = new Array();
				if($options.data.orgs){
					if($options.showUser){
						$options.data.orgs.forEach(function(org){
							if(org){
								if(org.parent == orgId){
									org.users = getUsers(org.id);
									orgChildren.push(org);
								}
							}
						});
					}else{
						orgChildren = $options.data.orgs.filterProperty('parent', orgId);
					}
				}
				return orgChildren;
			};

			/*
			* return 传入返回org下的所有用户
			*/
			function getUsers(orgId){
				var orgUsers = new Array();

				if(!$options.data.orgs || $options.data.orgs.length < 1){
					return $options.data.users;
				}

				if($options.data.users){
					orgUsers = $options.data.users.filterProperty('organizations',orgId);
				}
				return orgUsers;
			}
			
		})();
	});
}(function (deps, factory) {
	 window.SelectTag = factory(window.jQuery);
}));


Handlebars.registerHelper('orgList', function(items, tagType, showUser, options) {
  var out = "";
  if(!items) 
  	return;

  if(showUser){
      for(var i=0, l=items.length; i<l; i++) {
        out = out + "<li><a href=\"javascript:SelectTag.reload(\'"+items[i].id+"\')\">" + options.fn(items[i]);
        if(items[i].users){
        	out = out + "<span class='label label-default pull-right'>" + items[i].users.length + "</span>";
        }

        out = out + "</a></li>";
      }
  }else{
        items.forEach(function(item){
            out = out + "<li><a class='org'><label style='cursor:pointer'><input style='margin-top:0;vertical-align:middle' type='"+tagType+"' onClick='SelectTag.checked(this)' name='selectTag-org' id='"+item.id+"' value='"+item.id+"'><span style='vertical-align:middle;padding-left:4px'>" + options.fn(item) + "</span></label>";

            if(item.children && item.children.length > 0){
                out = out + "<span class='pull-right' style='cursor:pointer;width:30px;text-align:right' onClick=\"javascript:SelectTag.reload(\'"+item.id+"\')\"><i class='fa fa-angle-right' aria-hidden='true'></i></span>";
            }
            out = out + "</a></li>";
        });
  }
	
  return new Handlebars.SafeString(out);
});

Handlebars.registerHelper('userList', function(items, tagType, options) {
  var out = "";
  if(!items) 
  	return;
  for(var i=0, l=items.length; i<l; i++) {
    out = out + "<tr><td><a class='user'><label style='cursor:pointer'><input style='margin-top:0;vertical-align:middle' type='"+tagType+"' onClick='SelectTag.checked(this)' name='selectTag-user' id='"+items[i].id+"' value='"+items[i].id+"'><span style='vertical-align:middle;padding-left:4px'><img data-name='" + options.fn(items[i]) + "' class='selectTag-profile img-circle'>" + options.fn(items[i]) + "</span></label></a></td></tr>";
  }
	
  return new Handlebars.SafeString(out);
});

Handlebars.registerHelper('breadcrumb', function(data) {
  var out = "";
  if(!data) 
  	return;
  function getLi(org){
  	if (!org || !org.name || org.name =='')
  		return "";
  	var o = '<li><a href="javascript:SelectTag.reload(\''+org.id+'\')">'+org.name+"</a></li>"
  	if(org.parentOrg){
  		o = getLi(org.parentOrg) + o;
  	}
  	return o;
  }
	
  out = getLi(data.parentOrg);
  out = '<li><a href="javascript:SelectTag.reload(\'\')"><i class="fa fa-home"></i></a></li>' 
  		+ out;
  if(data.id && data.id !=0 && data.id !=''){
  	out = out + '<li class="active"><a href="javascript:SelectTag.reload(\''+data.id+'\')">'+data.name+'</a></li>'
  }
  return new Handlebars.SafeString(out);
});