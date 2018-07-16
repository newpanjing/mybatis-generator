package com.qikenet.build;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.util.*;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import freemarker.template.Configuration;
import freemarker.template.Template;

/**
 * mybatis代码生成器<br/>
 * 直接运行这个类，配置在resources里面的config.json
 * @author panjing
 * @project build-code	
 * @date 2016年6月14日 下午5:43:59
 */
@SuppressWarnings("unchecked")
public class BuildHelper {

	private String targetPath;

	public BuildHelper() {
		this.targetPath = new File(this.getClass().getResource("/").getFile()).getParent() + "/files";
		// 新建和清空之前的文件
		File targetFile = new File(targetPath);
		if (!targetFile.exists()) {
			targetFile.mkdirs();
		} else {
			File[] files = targetFile.listFiles();
			for (File file : files) {
				file.delete();
			}
		}
	}

	public static void main(String[] args) {

		try {
			new BuildHelper().build();
			System.out.println("build success.");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void build() throws Exception {

		List<Map<Object, Object>> modules = handlerInfo();
		for (Map<Object, Object> map : modules) {
			List<String> packages = new ArrayList<String>();
			// 处理包导入的包
			List<Map<Object, Object>> columns = (List<Map<Object, Object>>) map.get("columns");
			for (Map<Object, Object> map2 : columns) {
				String packageName = (String) map2.get("package");
				if (!packages.contains(packageName)) {
					packages.add(packageName);
				}
			}
			map.put("packages", packages);
			List<Map<String, String>> templates = (List<Map<String, String>>) map.get("templates");
			for(Map<String,String> template:templates){
				buildTemplate(template, map);
			}

		}
	}

	public Template getTemplate(String name) {

		try {
			// 通过Freemaker的Configuration读取相应的ftl
			Configuration cfg = new Configuration();
			// 设定去哪里读取相应的ftl模板文件
			cfg.setClassForTemplateLoading(this.getClass(), "/templates");
			// 在模板文件目录中找到名称为name的文件
			Template temp = cfg.getTemplate(name);
			return temp;
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 解析模板
	 * @param template
	 * @param tableMap
	 */
	public void buildTemplate(Map<String,String> template, Map<Object, Object> tableMap) {

		// 通过Template可以将模板文件输出到相应的流
		try {
			Template temp = this.getTemplate(template.get("template"));

			// 将流输出到文件
			File dir = new File(template.get("outPath") + "/");
			if (!dir.exists()) {
				dir.mkdirs();
			}

			String filePath = String.valueOf(tableMap.get("basePath")) + dir.getPath() + "/" + tableMap.get("modelName") + template.get("outSuffix");

			File target = new File(filePath);
			File dirTarget=new File(target.getParent());
			if(!dirTarget.exists()){
				dirTarget.mkdirs();
			}
			if (!target.exists()) {
				target.createNewFile();
			}
			System.out.println(target);
			FileWriter fw = new FileWriter(target);

			//扩展字段
			Set<String> keys = template.keySet();
			for (String key : keys) {
				if (!tableMap.containsKey(key)) {
					tableMap.put(key, template.get(key));
				}
			}

			temp.process(tableMap, fw);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 解析配置信息
	 * @return
	 * @throws Exception
	 */
	public List<Map<Object, Object>> handlerInfo() throws Exception {

		JSONObject jsonObject = getConfig();
		// 获取数据库连接
		Map<String, Object> jdbcMap = (Map<String, Object>) jsonObject.get("jdbc");
		String username = (String) jdbcMap.get("username");
		String password = (String) jdbcMap.get("password");
		String url = (String) jdbcMap.get("url");

		String author = jsonObject.getString("author");

		//输出目录根路径
		String basePath = jsonObject.getString("basePath");
		if (basePath == null) {
			basePath = "";
		}

		Class.forName("com.mysql.jdbc.Driver").newInstance();
		String basePackage = (String) jsonObject.get("package");
		JSONArray templates = jsonObject.getJSONArray("templates");
		// 获取表
		Map<String, Object> tableMapping = (Map<String, Object>) jsonObject.get("tableMapping");

		List<Map<Object, Object>> modules = new ArrayList<Map<Object, Object>>();

		for (String table : tableMapping.keySet()) {
			System.out.println("table : " + table);
			Map<String, String> tableInfo = (Map<String, String>) tableMapping.get(table);
			String modelName = tableInfo.get("name");

			String tableRemark = tableInfo.get("remark");
			System.out.println("tableRemark : " + tableRemark);
			Map<Object, Object> tableMap = new HashMap<Object, Object>();
			tableMap.put("tableName", table);
			tableMap.put("modelName", modelName);
			StringBuffer requestUrl=new StringBuffer();
			char [] chars= modelName.toCharArray();
			for (char c :chars ) {
			    if(Character.isUpperCase(c)){
			    	requestUrl.append("/");
				}
				requestUrl.append(c);
			}
			tableMap.put("requestUrl",requestUrl.toString().toLowerCase());

			List<Map<Object, Object>> columns = new ArrayList<Map<Object, Object>>();

			Connection conn = DriverManager.getConnection(url, username, password);
			DatabaseMetaData databaseMetaData = conn.getMetaData();
			ResultSet rs = databaseMetaData.getColumns(null, "%", table, "%");

			String idField = "id";

			ResultSet tableRs = databaseMetaData.getPrimaryKeys(null, null, table);
			// 如果存在多个主键 就取第一个
			if (tableRs.next()) {
				String columnName = tableRs.getString("COLUMN_NAME");
				idField = columnName;
			}

			while (rs.next()) {
				Map<Object, Object> colMap = new HashMap<Object, Object>();

				String name = rs.getString("COLUMN_NAME");
				String remark = rs.getString("REMARKS");
				String type = rs.getString("TYPE_NAME");

				String fieldName = "";
				String[] strs = name.split("_");
				boolean isFirs = false;

				for (String string : strs) {
					if (isFirs) {
						fieldName += firstUp(string);
					} else {
						fieldName += firstLow(string);
						isFirs = true;
					}
				}
				colMap.put("remark", remark);
				colMap.put("name", name);
				colMap.put("fieldName", fieldName);
				Map<String ,String> typeMapper=new HashMap<String, String>();
				typeMapper.put("INT","INTEGER");
				typeMapper.put("DATETIME","TIMESTAMP");

				if(typeMapper.containsKey(type)){
					type=typeMapper.get(type);
				}
				colMap.put("type",type);
				colMap.putAll(handlerType(type));
				columns.add(colMap);
			}

			tableMap.put("idField", idField);
			
			String idFieldName = "";
			String[] strs = idField.split("_");
			boolean isFirs = false;

			for (String string : strs) {
				if (isFirs) {
					idFieldName += firstUp(string);
				} else {
					idFieldName += firstLow(string);
					isFirs = true;
				}
			}

			//设置basePath
			tableMap.put("basePath", basePath);

			tableMap.put("idFieldName", idFieldName);
			tableMap.put("package", basePackage);
			tableMap.put("templates", templates);
			tableMap.put("columns", columns);
			tableMap.put("modelRemark", tableRemark);
			tableMap.put("author", author);
			//当前日期
			tableMap.put("now", new Date());


			modules.add(tableMap);
		}
		return modules;
	}

	/**
	 * 类型处理
	 * @param type
	 * @return
	 */
	public Map<String, Object> handlerType(String type) {

		Map<String, Object> rs = new HashMap<String, Object>();

		String[] longs = new String[] { "TINYINT", "SMALLINT", "MEDIUMINT", "BIGINT" };
		String[] strings = new String[] { "VARCHAR", "CHAR", "TEXT", "MEDIUMTEXT" };
		String[] ints = new String[] {"INTEGER","INT", "BIT", "BOOLEAN" };
		String[] doubles = new String[] { "FLOAT", "DOUBLE", "DECIMAL" };
		String[] dates = new String[] { "DATE", "TIME", "DATETIME", "TIMESTAMP", "YEAR" };

		if (Arrays.asList(longs).contains(type)) {
			rs.put("package", "java.lang.Long");
			rs.put("typeName", "Long");
		} else if (Arrays.asList(strings).contains(type)) {
			rs.put("package", "java.lang.String");
			rs.put("typeName", "String");
		} else if (Arrays.asList(ints).contains(type)) {
			rs.put("package", "java.lang.Integer");
			rs.put("typeName", "Integer");
		} else if (Arrays.asList(doubles).contains(type)) {
			rs.put("package", "java.lang.Double");
			rs.put("typeName", "Double");
		} else if (Arrays.asList(dates).contains(type)) {
			rs.put("package", "java.util.Date");
			rs.put("typeName", "Date");
		} else {
			rs.put("package", "java.lang.Object");
			rs.put("typeName", "Object");
		}

		return rs;
	}

	/**
	 * 加载配置
	 * @return
	 * @throws Exception
	 */
	public JSONObject getConfig() throws Exception {

		// 读取配置
		InputStream in = BuildHelper.class.getResourceAsStream("/config.json");
		InputStreamReader isr = new InputStreamReader(in, "utf-8");// 考虑到编码格式
		BufferedReader br = new BufferedReader(isr);
		StringBuffer str = new StringBuffer();
		String line = null;
		while ((line = br.readLine()) != null) {
			str.append(line);
		}
		br.close();
		System.out.println(str);
		return JSON.parseObject(str.toString());

	}

	/**
	 * 首字母小写
	 * @param str
	 * @return
	 */
	public String firstLow(String str) {

		if (str.length() > 1) {
			str = str.substring(0, 1).toLowerCase() + str.substring(1, str.length());
		} else {
			str = str.toLowerCase();
		}
		return str;
	}

	/**
	 * 首字母大写
	 * @param str
	 * @return
	 */
	public String firstUp(String str) {

		if (str.length() > 1) {
			str = str.substring(0, 1).toUpperCase() + str.substring(1, str.length());
		} else {
			str = str.toUpperCase();
		}
		return str;
	}

}
