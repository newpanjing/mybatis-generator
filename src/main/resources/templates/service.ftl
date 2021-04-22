package ${package}.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;

import com.yzt.eface.entity.${modelName};

/**
 * ${modelRemark} 服务类
 * @author ${author}
 * @project ${project}
 * @date  ${now?datetime}
 */
public interface ${modelName}Service extends IService<${modelName}>{

    /**
     * 根据传入的参数进行查询分页
     * @param ${modelName?uncap_first}
     * @return
     */
    IPage<${modelName}> gePageList(${modelName} ${modelName?uncap_first});

    /**
     * 根据id 删除
     *
     * @param id
     * @return
     */
    boolean deleteById(String id);

}
