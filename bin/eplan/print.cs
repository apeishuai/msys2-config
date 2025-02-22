using System;
using System.Reflection;

namespace EplanApiTest
{
    class Program
    {
        static void Main(string[] args)
        {
            // 获取 Eplan.EplApi 命名空间的类型
            var eplanApiNamespace = typeof(Eplan.EplApi.Base.EObject).Namespace;

            // 获取 Eplan.EplApi 命名空间中的所有类型和成员
            var typesAndMembers = Assembly.GetAssembly(typeof(Eplan.EplApi.Base.EObject))
                .GetTypes()
                .Where(t => t.Namespace == eplanApiNamespace)
                .SelectMany(t => t.GetMembers());

            // 打印出所有类型和成员名称
            foreach (var member in typesAndMembers)
            {
                Console.WriteLine(member.Name);
            }

            Console.ReadLine();
        }
    }
}