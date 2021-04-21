package ${package}.controller;


import com.yzt.eface.entity.${modelName};
import com.yzt.eface.service.${modelName}Service;

import com.yzt.eface.utils.Result;
import com.yzt.eface.utils.StatusCode;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.baomidou.mybatisplus.core.metadata.IPage;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

/**
 * ${modelRemark} 控制器
 * @author ${author}
 * @project ${project}
 * @date  ${now?datetime}
 */
@Api(tags = "${modelRemark}")
@RestController
@RequestMapping("${requestUrl}")
public class ${modelName}Controller extends BaseController{

    <#if modelName??>
        <#assign  lower= modelName?uncap_first >
        <#assign service=lower+"Service" >
    </#if>
    @Autowired
    private ${modelName}Service ${service};

    /**
     * 新增或者修改
     *
     * @param ${lower}
     * @return
    */
    @ApiOperation(value = "新增或修改", notes = "如果id=null就是新增如，id!=null就是修改")
    @RequestMapping(value = "/saveOrUpdate", method = RequestMethod.POST)
    public Result saveOrUpdate(@RequestBody ${modelName} ${lower}){
        Result result = Result.getError(StatusCode.SYSTEM_ERROR);

        boolean flag = ${service}.saveOrUpdate(${lower});

        if (flag){
            result = Result.getSuccess();
        }

        return result;
    }

    /**
	 * 删除
     *
	 * @param ${lower}
	 * @return
	 */
    @ApiOperation(value = "删除", notes = "根据id删除")
	@RequestMapping(value = "/del", method = RequestMethod.POST)
	public Result del(@RequestBody ${modelName} ${lower}){
		Result result = Result.getError();
		if (${lower}.getId() != null && StringUtils.isNotBlank(${lower}.getId())){
			boolean flag = ${service}.removeById(${lower}.getId());
			if (flag){
				result = Result.getSuccess();
			}
		}
		return result;
	}

    /**
	 * 列表
     *
	 * @param ${lower}
	 * @return
	 */
    @ApiResponses(@ApiResponse(code = 200, message = "处理成功", response = ${modelName}.class))
    @ApiOperation(value = "列表分页", notes = "根据page和rows进行分页，sort和order进行排序")
	@RequestMapping(value = "/list", method = RequestMethod.POST)
    public Result getPageList(@RequestBody ${modelName} ${lower}){

        IPage<${modelName}> page = ${service}.gePageList(${lower});
        return Result.getSuccess(page);
    }

}



