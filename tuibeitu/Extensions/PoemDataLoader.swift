//
//  PoemDataLoader.swift
//  tuibeitu
//
//  Created by s s Flood on 2026/1/3.
//

import Foundation
import SwiftUI

// 定义回调协议，用于处理数据加载结果
struct PoemDataLoader {
    static func loadPoemData(completion: @escaping (Result<[PoemItem], Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            // 检查 bundle 中的文件
            print("Bundle 路径: \(Bundle.main.bundlePath)")
            
            // 尝试多种可能的路径
            var jsonData: Data?
            var foundPath: String?
            
            let possiblePaths = [
                Bundle.main.path(forResource: "data/poem", ofType: "json"),
                Bundle.main.path(forResource: "poem", ofType: "json", inDirectory: "data"),
                Bundle.main.path(forResource: "poem", ofType: "json")
            ]
            
            for path in possiblePaths {
                if let filePath = path {
                    print("找到可能的路径: \(filePath)")
                    if let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) {
                        jsonData = data
                        foundPath = filePath
                        print("成功读取文件: \(filePath)")
                        break
                    } else {
                        print("读取失败: \(filePath)")
                    }
                }
            }
            
            if let data = jsonData {
                print("JSON 数据大小: \(data.count) 字节")
                
                // 打印前几个字符以检查格式
                if let jsonString = String(data: data.prefix(200), encoding: .utf8) {
                    print("JSON 前缀: \(jsonString)")
                }
                
                do {
                    let decoder = JSONDecoder()
                    // 设置日期格式等选项（如果需要）
                    let items = try decoder.decode([PoemItem].self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(.success(items))
                    }
                } catch let DecodingError.keyNotFound(key, context) {
                    let error = "解码错误 - 找不到键: \(key), 路径: \(context.codingPath), 详细信息: \(context.debugDescription)"
                    print(error)
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: error, code: 0, userInfo: nil)))
                    }
                } catch let DecodingError.valueNotFound(value, context) {
                    let error = "解码错误 - 找不到值: \(value), 路径: \(context.codingPath), 详细信息: \(context.debugDescription)"
                    print(error)
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: error, code: 0, userInfo: nil)))
                    }
                } catch let DecodingError.typeMismatch(type, context) {
                    let error = "解码错误 - 类型不匹配: \(type), 路径: \(context.codingPath), 详细信息: \(context.debugDescription)"
                    print(error)
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: error, code: 0, userInfo: nil)))
                    }
                } catch let error as DecodingError {
                    print("解码错误: \(error)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                } catch {
                    print("其他错误: \(error)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            } else {
                print("在bundle中找不到poem.json文件")
                
                // 如果无法从bundle加载，使用嵌入的数据
                DispatchQueue.main.async {
                    completion(.success(Self.embeddedPoemData))
                }
            }
        }
    }
    
    // 嵌入的示例数据
    private static let embeddedPoemData: [PoemItem] = [
        PoemItem(
            title: Title(sn: "一", ganZhi: "甲子", hexagrams1: "乾下乾上", hexagrams2: "乾"),
            poem: Poem(
                predict: [["茫茫天地", "不知所止"], ["日月循环", "周而复始"]],
                description: [["自从盘古迄希夷", "虎斗龙争事正奇"], ["悟得循环真谛在", "试于唐后论元机"]]
            )
        ),
        PoemItem(
            title: Title(sn: "二", ganZhi: "乙丑", hexagrams1: "巽下乾上", hexagrams2: "姤"),
            poem: Poem(
                predict: [["累累硕果", "莫明其数"], ["一果一仁", "即新即故"]],
                description: [["万物土中生", "二九先成实"], ["一统定中原", "阴盛阳先竭"]]
            )
        ),
        PoemItem(
            title: Title(sn: "三", ganZhi: "丙寅", hexagrams1: "艮下乾上", hexagrams2: "遁"),
            poem: Poem(
                predict: [["日月当空", "照临下土"], ["扑朔迷离", "不文亦武"]],
                description: [["参遍空王色相空", "一朝重入帝王宫"], ["悟得循环真谛在", "喔喔晨鸡孰是雄"]]
            )
        )
    ]
    
    // 加载注解数据
    static func loadAnnotationData(completion: @escaping (Result<[String], Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            // 尝试加载注解数据
            var jsonData: Data?
            var foundPath: String?
            
            let possiblePaths = [
                Bundle.main.path(forResource: "data/annotion", ofType: "json"),
                Bundle.main.path(forResource: "annotion", ofType: "json", inDirectory: "data"),
                Bundle.main.path(forResource: "annotion", ofType: "json")
            ]
            
            for path in possiblePaths {
                if let filePath = path {
                    print("找到注解文件可能的路径: \(filePath)")
                    if let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) {
                        jsonData = data
                        foundPath = filePath
                        print("成功读取注解文件: \(filePath)")
                        break
                    } else {
                        print("注解文件读取失败: \(filePath)")
                    }
                }
            }
            
            if let data = jsonData {
                do {
                    let annotations = try JSONDecoder().decode([String].self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(annotations))
                    }
                } catch {
                    print("注解数据解码错误: \(error)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            } else {
                print("在bundle中找不到annotion.json文件")
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "annotion.json not found", code: 0, userInfo: nil)))
                }
            }
        }
    }
}